//
//  Player.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      13.04.21
//

import AVFoundation
import ReactiveSwift

protocol UVPlayerType {
    func play(_ url: URL) -> SignalProducer<Void, Error>
    func pause()
}

final class UVVoicePlayer: UVAudioSettings {
    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
//        let format = playerNode.outputFormat(forBus: 0)
//        engine.connect(mixerNode, to: engine.mainMixerNode, format: format)

//        let format = engine.mainMixerNode.outputFormat(forBus: 0)
//        let format = engine.mainMixerNode.inputFormat(forBus: 1)
//
//        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
//        engine.connect(mixerNode, to: engine.mainMixerNode, format: format)

        return engine
    }()

    private let mixerNode: AVAudioMixerNode = AVAudioMixerNode()
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()

    // MARK: -

    init() {
//        engine.prepare()
    }
}

extension UVVoicePlayer: UVPlayerType {
    func play(_ url: URL) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            do {
//                let player = try AVAudioPlayer(contentsOf: url)

                let audioFile = try AVAudioFile(forReading: url)
//                let format = audioFile.processingFormat
//                engine.connect(playerNode, to: mixerNode, format: format)

//                playerNode.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { (_) in
//                    observer.send(.completed)
//                }
//
////                engine.connect(playerNode, to: engine.mainMixerNode, format: format)
//                if !engine.isRunning {
//
//                    try engine.start()
//                }
//                playerNode.play()
//                observer.send(value: ())

//                let audioFormat = audioFile.processingFormat
//                let audioFrameCount = UInt32(audioFile.length)
//                guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)  else { return }
//                do {
//                    try audioFile.read(into: audioFileBuffer)
//                } catch {
//                    print("over")
//                }
//
                try engine.start()

                playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
                playerNode.play()
//                playerNode.scheduleBuffer(audioFileBuffer, at: nil, options: AVAudioPlayerNodeBufferOptions.loops)

            } catch {
                print(error.localizedDescription)
                observer.send(error: error)
            }
        }
    }

    func pause() {
        playerNode.pause()
        engine.pause()
    }
}
