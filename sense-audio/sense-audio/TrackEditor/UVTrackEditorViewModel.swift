//
//  UVTrackEditorViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      02.05.2021
//

import Foundation
import ReactiveSwift

protocol UVTrackEditorViewModelType {
    var toolbox: UVToolbox { get }
    func play() -> SignalProducer<Void, Never>
    func pause() -> SignalProducer<Void, Never>
}

final class UVTrackEditorViewModel {
    
    let toolbox: UVToolbox = UVToolbox()
    
    private let coordinator: UVCoordinatorType
    private let editor: UVEditorType
    private let project: String
    private let track: UVTrackModel
    private let fileManager: UVFileManagerType

    init(coordinator: UVCoordinatorType,
         editor: UVEditorType,
         project: String,
         track: UVTrackModel,
         manager: UVFileManagerType = UVFileManager()) {
        self.coordinator = coordinator
        self.editor = editor

        self.project = project
        self.track = track
        fileManager = manager
        
        
        editor.load(asset: track.url)
    }
}

// MARK: - UVTrackEditorViewModelType

extension UVTrackEditorViewModel: UVTrackEditorViewModelType {
    func play() -> SignalProducer<Void, Never> {
        SignalProducer { [self] (observer, _) in
            observer.send(value: ())
        }
    }

    func pause() -> SignalProducer<Void, Never> {
        SignalProducer { (observer, _) in
            print("paused!")
            observer.send(value: ())
        }
    }
}
