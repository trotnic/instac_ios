//
//  UVPlayerViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import Foundation
import ReactiveSwift


/**
 This type is used for playback
 of just recorded assets
 */

protocol UVPlayerViewModelType {
    func play(track name: String) -> SignalProducer<Void, Error>
    func pause() -> SignalProducer<Void, Never>
    func stop()
}

struct UVPlayerViewModel {
    private let player: UVPlayerType = UVVoicePlayer()
    private let fileManager: UVFileManagerType
    
    init(fileManager: UVFileManagerType) {
        self.fileManager = fileManager
    }
}

extension UVPlayerViewModel: UVPlayerViewModelType {
    func play(track name: String) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            fileManager.url(for: name)
                .on(value: { fileURL in
                    player.play(fileURL)
                        .on(event: { event in
                            switch event {
                            case .completed:
                                DispatchQueue.main.sync {
                                    observer.send(.completed)
                                }
                            case .value:
                                observer.send(value: (()))
                            default:
                                break
                            }
                        })
                        .start()
                })
                .start()
        }
    }
    
    func pause() -> SignalProducer<Void, Never> {
        SignalProducer { (observer, _) in
            player.pause()
            observer.send(value: ())
        }
    }
    
    func stop() {
        
    }
}
