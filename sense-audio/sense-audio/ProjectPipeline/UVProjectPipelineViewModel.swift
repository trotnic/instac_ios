//
//  UVProjectPipelineViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import UIKit
import AVFoundation
import ReactiveSwift

protocol UVProjectPipelineViewModelType {
    var contents: Signal<[UVTrackModel], Never> { get }
//    var contents: SignalProducer<[UVTrackModel], Never> { get }

    func requestContents()
    
    func addTrack()
    func deleteTrack(at index: Int) -> SignalProducer<Void, Error>
    func editTrack(at index: Int)
//    func didSelect(at index: Int) -> SignalProducer<Void, Never>

    func play()
}

final class UVProjectPipelineViewModel {

    // MARK: - Properties
    
    var contents: Signal<[UVTrackModel], Never> { _contents.signal }

    private let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType
    private let dataManager: UVDataManager = .shared
    private let pipelineManager: UVPipelineManagerType
    private let _contents: MutableProperty<[UVTrackModel]> = MutableProperty([])

    private var project: UVProjectModel

//    private lazy var composition: AVCompositionTrack = {
//
//    }()

    // MARK: - Initialization

    init(coordinator: UVCoordinatorType, pipeline: UVPipelineManagerType, fileManager: UVFileManagerType, project: UVProjectModel) {
        self.coordinator = coordinator
        self.fileManager = fileManager
        pipelineManager = pipeline
        self.project = project
    }
}

// MARK: - Private interface

private extension UVProjectPipelineViewModel {
    
}

// MARK: - UVProjectPipelineViewModelType

extension UVProjectPipelineViewModel: UVProjectPipelineViewModelType {

    func requestContents() {
        dataManager.getTracks(for: project.id)
            .observe(on: QueueScheduler.main)
            .on(value: { contents in
                self._contents.value = contents
            })
            .start()
    }
    
    func addTrack() {
        coordinator.show(route: .projectTrackRecorder(project: project))
    }

    func deleteTrack(at index: Int) -> SignalProducer<Void, Error> {
        let track = _contents.value[index]
        
        return dataManager.delete(.track(track))
            .on(value: { [self] in
                try? fileManager.delete(track: track.name, in: project.name)
            })
    }

    func editTrack(at index: Int) {
        let track = _contents.value[index]
        coordinator.show(route: .projectTrackEditor(project: project, track: track))
    }

//    func didSelect(at index: Int) -> SignalProducer<Void, Never> {
//        contents
//            .map({ $0[index] })
//            .flatMap(.latest) { track -> SignalProducer<Void, Never> in
//                SignalProducer { [self] (observer, _) in
//                    coordinator.show(route: .projectTrackEditor(project: project, track: track))
//                    observer.send(value: ())
//                }
//            }
//    }

    func play() {
        pipelineManager.attach(files: _contents.value)
        pipelineManager.play()
    }
}

// MARK: - UITableViewDatasource

// extension UVProjectPipelineViewModel: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
// }
