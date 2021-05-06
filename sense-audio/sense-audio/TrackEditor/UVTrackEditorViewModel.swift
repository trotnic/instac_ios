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
    func play() -> SignalProducer<Void, Never>
    func pause() -> SignalProducer<Void, Never>
}

final class UVTrackEditorViewModel {

    private let coordinator: UVCoordinatorType
    private let editor: UVEditorType
    private let project: String
    private let track: String
    private let fileManager: UVFileManagerType

    init(coordinator: UVCoordinatorType,
         editor: UVEditorType,
         project: String,
         track: String,
         manager: UVFileManagerType = UVFileManager()) {
        self.coordinator = coordinator
        self.editor = editor
        self.project = project
        self.track = track
        fileManager = manager
    }
}

// MARK: - UVTrackEditorViewModelType

extension UVTrackEditorViewModel: UVTrackEditorViewModelType {
    func play() -> SignalProducer<Void, Never> {
        SignalProducer { (observer, _) in
            print("playing!")
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
