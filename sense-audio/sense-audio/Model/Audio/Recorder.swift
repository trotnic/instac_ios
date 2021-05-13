//
//  Recorder.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      31.03.21
//

import AVFoundation
import ReactiveSwift

protocol RecorderType {
    var playbackEnd: Signal<Void, Never> { get }
    var playbackTime: Signal<Float, Never> { get }
    
    func record(_ fileURL: URL) throws
    func stop()
    
    func play(_ fileURL: URL)
}

final class UVVoiceRecorder: UVAudioSettings {
    
    private lazy var recordEngine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.attach(mixerNode)
        engine.connect(engine.inputNode, to: mixerNode, format: format)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: format)
        return engine
    }()

    private lazy var playerEngine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        return engine
    }()

    private let mixerNode = AVAudioMixerNode()
    private let playerNode = AVAudioPlayerNode()

    var playbackEnd: Signal<Void, Never> { _playbackEnd }
    var playbackTime: Signal<Float, Never> { _playbackTime }
    
    private let (_playbackEnd, _playbackEndObserver) = Signal<Void, Never>.pipe()
    private let (_playbackTime, _playbackTimeObserver) = Signal<Float, Never>.pipe()
    
    var audioFile: AVAudioFile? {
      didSet {
        if let audioFile = audioFile {
          audioLengthSamples = audioFile.length
          audioLengthSeconds = Float(audioLengthSamples) / audioSampleRate
        }
      }
    }

    
    var audioSampleRate: Float = 44100
    var audioLengthSeconds: Float = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var currentFrame: AVAudioFramePosition {
      guard let lastRenderTime = playerNode.lastRenderTime,
        let playerTime = playerNode.playerTime(forNodeTime: lastRenderTime) else {
          return 0
      }

      return playerTime.sampleTime
    }
    var currentPosition: AVAudioFramePosition = 0

    
    // MARK: -

    init() {
        recordEngine.prepare()
        playerEngine.prepare()
    }
}

// MARK: - Private interface

private extension UVVoiceRecorder {
    func setupSession() {
        let session = AVAudioSession.shared
        try? session.setCategory(.playAndRecord)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}

// MARK: - RecorderType

extension UVVoiceRecorder: RecorderType {
    func record(_ fileURL: URL) throws {
        if recordEngine.isRunning {
            recordEngine.stop()
        }
        
        let audioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
        mixerNode.installTap(onBus: 0, bufferSize: bufferSize, format: format) { (pcmBuffer, _) in
            try? audioFile.write(from: pcmBuffer)
        }

        try? recordEngine.start()
    }

    func stop() {
        recordEngine.stop()
        mixerNode.removeTap(onBus: 0)
    }
    
    func play(_ fileURL: URL) {
        guard let audioFile = try? AVAudioFile(forReading: fileURL) else {
            return
        }
        self.audioFile = audioFile
        if !playerEngine.isRunning {
            try? playerEngine.start()
        }
        if playerNode.isPlaying {
            playerNode.stop()
        }
        
        let (timeSignal, timeObserver) = Signal<Void, Never>.pipe()
        
        timeSignal
            .observe { [self] event in
                switch event {
                case .value(_):
                    currentPosition = currentFrame
                    currentPosition = max(currentPosition, 0)
                    currentPosition = min(currentPosition, audioLengthSamples)
                    let time = Float(currentPosition) / audioSampleRate
                    _playbackTimeObserver.send(value: time)
                case .completed:
                    currentPosition = 0
                    _playbackTimeObserver.send(value: 0)
                default:
                    break
                }
            }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            timeObserver.send(value: ())
        }
        
        RunLoop.current .add(timer, forMode: .common)
                
        playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataPlayedBack) { [self] _ in
            _playbackEndObserver.send(value: ())
            timer.invalidate()
            timeObserver.sendCompleted()
        }
        playerNode.play()
    }
}
