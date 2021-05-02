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

final class UVVoicePlayer {
    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.attach(playerNode)
        engine.attach(mixerNode)
        
        let format = playerNode.outputFormat(forBus: 0)
        
        engine.connect(playerNode, to: mixerNode, format: format)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: format)
        
        return engine
    }()
    
    private let mixerNode: AVAudioMixerNode = AVAudioMixerNode()
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // MARK: -
    
    init() {
        engine.prepare()
    }
}

extension UVVoicePlayer: UVPlayerType {
    func play(_ url: URL) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            do {
                let file = try AVAudioFile(forReading: url)
                playerNode.scheduleFile(file, at: nil, completionCallbackType: .dataPlayedBack) { (_) in
                    observer.send(.completed)
                }
                if !engine.isRunning {
                    try engine.start()
                }
                playerNode.play()
                observer.send(value: ())
            } catch {
                observer.send(error: error)
            }
        }
    }
    
    func pause() {
        playerNode.pause()
        engine.pause()
    }
}
