//
//  UVPlayerViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import Foundation

protocol UVPlayerViewModelType {
    mutating func play(_ url: URL)
    mutating func pause()
    mutating func stop()
}

struct UVPlayerViewModel {
    private var player: UVPlayerType = {
        let player = UVVoicePlayer()
        return player
    }()
}

extension UVPlayerViewModel: UVPlayerViewModelType {
    func play(_ url: URL) {
        try? player.play(url)
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        
    }
}
