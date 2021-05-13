//
//  Editor.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      06.05.2021
//

import AVFoundation
import ReactiveSwift

/**
 
 # Nodes layout
 
 
 ```
       /--- equalizer --- mixer--\
      /---- reverb ------- mixer--\
 player                            -- main mixer
      \---- distortion --- mixer--/
       \--- delay ------- mixer--/
 ```
 */

protocol UVEditorType {
    var playbackEnd: Signal<Void, Never> { get }

    func load(track url: URL)
    func bind(to toolbox: UVToolbox)
    func play()
    func pause()
    func save() -> SignalProducer<Void, Never>
}

final class UVEditor: UVAudioSettings {
    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()

        engine.attach(mixerNode1)
        engine.attach(mixerNode2)
        engine.attach(mixerNode3)
        engine.attach(mixerNode4)

        engine.attach(playerNode)

        engine.attach(equalizerNode)
        engine.attach(distortionNode)
//        engine.attach(delayNode)
        engine.attach(reverbNode)

        let distortionPoint = AVAudioConnectionPoint(node: distortionNode, bus: 0)
        let delayPoint = AVAudioConnectionPoint(node: delayNode, bus: 0)
        let reverbPoint = AVAudioConnectionPoint(node: reverbNode, bus: 0)
        let equalizerPoint = AVAudioConnectionPoint(node: equalizerNode, bus: 0)

        engine.connect(playerNode, to: [distortionPoint, reverbPoint, equalizerPoint], fromBus: 0, format: format)

        engine.connect(reverbNode, to: mixerNode1, fromBus: 0, toBus: 0, format: format)
        engine.connect(equalizerNode, to: mixerNode2, fromBus: 0, toBus: 0, format: format)
//        engine.connect(delayNode, to: mixerNode3, fromBus: 0, toBus: 0, format: format)
        engine.connect(distortionNode, to: mixerNode4, fromBus: 0, toBus: 0, format: format)

        engine.connect(mixerNode1, to: engine.mainMixerNode, format: format)
        engine.connect(mixerNode2, to: engine.mainMixerNode, format: format)
//        engine.connect(mixerNode3, to: engine.mainMixerNode, format: format)
        engine.connect(mixerNode4, to: engine.mainMixerNode, format: format)

        return engine
    }()

    var playbackEnd: Signal<Void, Never> { _playbackEnd }
    private let mixerNode1 = AVAudioMixerNode()
    private let mixerNode2 = AVAudioMixerNode()
    private let mixerNode3 = AVAudioMixerNode()
    private let mixerNode4 = AVAudioMixerNode()

    private let playerNode = AVAudioPlayerNode()

    private let equalizerNode = AVAudioUnitEQ()
    private let distortionNode = AVAudioUnitDistortion()
    private let delayNode = AVAudioUnitDelay()
    private let reverbNode = AVAudioUnitReverb()

    private let track: UVTrackModel
    private var audioFile: AVAudioFile?
    private var lastRenderTime: AVAudioTime?

    private let (_playbackEnd, _playbackEndObserver) = Signal<Void, Never>.pipe()

    init(track: UVTrackModel) {
        self.track = track
        setupSession()
        engine.prepare()
    }
}

// MARK: - Private interface

private extension UVEditor {
    func setupSession() {
        let session = AVAudioSession.shared
        try? session.setCategory(.playAndRecord)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }

    func bindEQ(_ equalizer: UVEqualizer) {
        equalizer.isOn
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { isOn in
                self.equalizerNode.bypass = !isOn
            }

        equalizer.globalGain
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { gain in
                self.equalizerNode.globalGain = gain
            }
    }

    func bindDistortion(_ distortion: UVDistortion) {
        distortion.isOn
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { isOn in
                self.distortionNode.bypass = !isOn
            }

        distortion.preGain
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { preGain in
                self.distortionNode.preGain = preGain
            }

        distortion.wetDryMix
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { wetDryMix in
                self.distortionNode.wetDryMix = wetDryMix
            }

        distortion.preset
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { preset in
                self.distortionNode.loadFactoryPreset(preset)
            }
    }

    func bindDelay(_ delay: UVDelay) {
        delay.isOn
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { isOn in
                self.delayNode.bypass = !isOn
            }

        delay.delayTime
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { delayTime in
                self.delayNode.delayTime = delayTime
            }

        delay.feedback
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { feedback in
                self.delayNode.feedback = feedback
            }

        delay.lowPassCutoff
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { lowPassCutoff in
                self.delayNode.lowPassCutoff = lowPassCutoff
            }

        delay.wetDryMix
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { wetDryMix in
                self.delayNode.wetDryMix = wetDryMix
            }
    }

    func bindReverb(_ reverb: UVReverb) {
        reverb.isOn
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { isOn in
                self.reverbNode.bypass = !isOn
            }

        reverb.wetDryMix
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { wetDryMix in
                self.reverbNode.wetDryMix = wetDryMix
            }

        reverb.preset
            .signal
            .observe(on: QueueScheduler.audio)
            .observeValues { preset in
                self.reverbNode.loadFactoryPreset(preset)
            }
    }
}

// MARK: - UVEditorType

extension UVEditor: UVEditorType {
    func load(track url: URL) {
        audioFile = try? AVAudioFile(forReading: url)
    }

    func bind(to toolbox: UVToolbox) {
        bindEQ(toolbox.equalizer)
//        bindDelay(toolbox.delay)
        bindReverb(toolbox.reverb)
        bindDistortion(toolbox.distortion)
    }

    func play() {

        DispatchQueue.audioQueue.sync { [self] in
            guard let audioFile = audioFile else {
                return
            }
            if !engine.isRunning {
                try? engine.start()
            }
            playerNode.scheduleFile(audioFile, at: lastRenderTime, completionCallbackType: .dataPlayedBack) { _ in
                lastRenderTime = nil
                _playbackEndObserver.send(value: ())
            }

            playerNode.play()
        }
    }

    func pause() {
        DispatchQueue.audioQueue.sync { [self] in
            lastRenderTime = playerNode.lastRenderTime
            playerNode.pause()
        }
    }

    func save() -> SignalProducer<Void, Never> {
        // MARK: ⚠️ DEVELOP ZONE ⚠️
        SignalProducer { (observer, _) in
            observer.send(value: ())
        }

//        SignalProducer { [self] (observer, _) in
//
//            try? AVAudioSession.shared.setCategory(.record)
//            try? AVAudioSession.shared.setActive(true, options: [.notifyOthersOnDeactivation])
//
//            guard let sourceFile = audioFile else {
//                observer.sendCompleted()
//                return
//            }
//            engine.stop()
//
//            let format: AVAudioFormat = sourceFile.processingFormat
//            do {
//                let maxFrames: AVAudioFrameCount = 1024
//                try engine.enableManualRenderingMode(.offline, format: format,
//                                                     maximumFrameCount: maxFrames)
//                try engine.start()
//                playerNode.play()
//            } catch {
//                observer.send(error: error)
//                return
//            }
//
//
//            let buffer = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat,
//                                          frameCapacity: engine.manualRenderingMaximumFrameCount)!
//
//            var outputFile: AVAudioFile?
//            do {
//                let documentsURL = FileManager.default.temporaryDirectory
//                let outputURL = documentsURL.appendingPathComponent(sourceFile.url.lastPathComponent)
//                if FileManager.default.fileExists(atPath: outputURL.path) {
//                    try? FileManager.default.removeItem(at: outputURL)
//                }
//
//                outputFile = try AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)
//            } catch {
//                observer.send(error: error)
//                return
//            }
//
//            while engine.manualRenderingSampleTime < sourceFile.length {
//                do {
////                    let frameCount = sourceFile.length - engine.manualRenderingSampleTime
//                    let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(sourceFile.length - engine.manualRenderingSampleTime))
//
//                    let status = try engine.renderOffline(AVAudioFrameCount(framesToRender), to: buffer)
//
//                    switch status {
//
//                    case .success:
//                        // The data rendered successfully. Write it to the output file.
//                        try outputFile?.write(from: buffer)
//
//                    case .insufficientDataFromInputNode:
//                        // Applicable only when using the input node as one of the sources.
//                        break
//                    case .cannotDoInCurrentContext:
//                        // The engine couldn't render in the current render call.
//                        // Retry in the next iteration.
//                        break
//                    @unknown default:
//                        fatalError()
//                    }
//                } catch {
//                    observer.send(error: error)
//                    return
//                }
//            }
//
//            let resultURL = outputFile!.url
//            outputFile = nil
//
//            playerNode.stop()
//            engine.stop()
//            engine.disableManualRenderingMode()
//
//
//            observer.send(value: resultURL)
//
//        }
    }
}
