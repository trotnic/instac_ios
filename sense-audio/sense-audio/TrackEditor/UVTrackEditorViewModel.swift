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
    var playbackEnd: Signal<Void, Never> { get }

    var toolbox: UVToolbox { get }
    var audioFileURL: SignalProducer<URL?, Never> { get }

    func play() -> SignalProducer<Void, Never>
    func pause() -> SignalProducer<Void, Never>
    func save()
}

final class UVTrackEditorViewModel {

    var playbackEnd: Signal<Void, Never> { editor.playbackEnd }
    let toolbox: UVToolbox
    var audioFileURL: SignalProducer<URL?, Never> { _audioFileURL.producer }

    private let coordinator: UVCoordinatorType
    private let editor: UVEditorType
    private let project: UVProjectModel
    private var track: UVTrackModel
    private let dataManager: UVDataManager = .shared
    private var fileManager: UVFileManagerType = UVFileManager()
    private let _audioFileURL: MutableProperty<URL?> = MutableProperty(nil)

    init(coordinator: UVCoordinatorType,
         editor: UVEditorType,
         project: UVProjectModel,
         track: UVTrackModel) {
        self.coordinator = coordinator
        self.editor = editor

        self.project = project
        self.track = track
        self.toolbox = UVToolbox(model: track)

        fileManager.sampleURL(for: track.name, in: project.name)
            .on(value: { [self] trackURL in
                _audioFileURL.value = trackURL
                editor.bind(to: toolbox)
                editor.load(track: trackURL)
            })
            .start()
    }
}

// MARK: - UVTrackEditorViewModelType

extension UVTrackEditorViewModel: UVTrackEditorViewModelType {
    func play() -> SignalProducer<Void, Never> {
        SignalProducer { [self] (observer, _) in
            editor.play()
            observer.send(value: ())
        }
    }

    func pause() -> SignalProducer<Void, Never> {
        SignalProducer { (observer, _) in
            self.editor.pause()
            observer.send(value: ())
        }
    }

    func save() {
        editor.save()
            .on(value: { [self] in

                // MARK: ⚠️ DEVELOP ZONE ⚠️
//                try? fileManager.delete(track: track.name, in: project.name)
//                try? fileManager.move(fileAt: newFileURL, to: project.name)

                dataManager.update(.track(toolbox.trackModel)).start()
                coordinator.back()
            })
            .start()
    }
}
