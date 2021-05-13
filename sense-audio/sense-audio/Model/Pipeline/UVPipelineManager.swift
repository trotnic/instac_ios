//
//  UVPipelineManager.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation
import AVFoundation
import ReactiveSwift

/**
 An interface for interacting with a project.
 Defines a work environment for project.
 
 - Warning: Should track for changes in the actual project
 and notify user if he leaves them unsaved
 */

// MARK: OBSOLETE

protocol UVPipelineManagerType {
    func attach(files: [UVTrackModel])
    func play()
}

final class UVPipelineManager {
    private var playerNodes: [AVAudioPlayerNode] = []

    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()
//        engine.attach(playerNode)
        engine.attach(mixerNode)

//        let format = playerNode.outputFormat(forBus: 0)

//        engine.connect(playerNode, to: mixerNode, format: format)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: mixerNode.inputFormat(forBus: 0))

        return engine
    }()

    private let mixerNode: AVAudioMixerNode = AVAudioMixerNode()
    private let playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    private let anotherPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()

    init() {
//        try? engine.start()
    }
}

extension UVPipelineManager: UVPipelineManagerType {
    func attach(files: [UVTrackModel]) {
//        let format = mixerNode.inputFormat(forBus: 0)

//        files.forEach { _ in
//            if let file = try? AVAudioFile(forReading: model.url) {
////                playerNode.schedule
//                let playerNode = AVAudioPlayerNode()
//
//                engine.attach(playerNode)
//                engine.connect(playerNode, to: mixerNode, format: format)
//
//                playerNode.scheduleFile(file, at: nil)
//
//                model.volume
//                    .producer
//                    .on(value: { print($0) })
//                    .on(value: { volume in
//                        print(volume)
//                        playerNode.volume = volume
//                    })
//                    .start()
//
//                playerNodes.append(playerNode)
//
//            }
//        }

//        engine.attach(anotherPlayerNode)
//        engine.connect(anotherPlayerNode, to: mixerNode, format: playerNode.outputFormat(forBus: 0))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.playerNode.play()
//        }

    }

    func play() {
        try? engine.start()
        playerNodes.forEach { (node) in
            node.play()
        }

    }
}
