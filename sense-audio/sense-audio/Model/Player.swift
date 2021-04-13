//
//  Player.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      13.04.21
//

import AVFoundation

protocol UVPlayerType {
    func play(_ url: URL) throws
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
    
    private lazy var mixerNode: AVAudioMixerNode = {
        AVAudioMixerNode()
    }()
    
    private lazy var playerNode: AVAudioPlayerNode = {
        AVAudioPlayerNode()
    }()
    
    // MARK: -
    
    init() {
        engine.prepare()
    }
}

extension UVVoicePlayer: UVPlayerType {
    func play(_ url: URL) throws {
        
        if let file = try? AVAudioFile(forReading: url) {
            playerNode.scheduleFile(file, at: nil)
            if !engine.isRunning {
                try engine.start()
            }
            playerNode.play()
        }
    }
    
    func pause() {
        playerNode.pause()
        engine.pause()
    }
}
