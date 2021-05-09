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
    var contents: SignalProducer<[UVTrackModel], Never> { get }

    func addTrack() -> SignalProducer<Void, Never>
    func deleteTrack(at index: Int) -> SignalProducer<Void, Error>
    func editTrack(at index: Int)
    func didSelect(at index: Int) -> SignalProducer<Void, Never>

    func play()
}

final class UVProjectPipelineViewModel {

    // MARK: - Properties

    let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType
    private let pipelineManager: UVPipelineManagerType
    private lazy var assets: SignalProducer<[UVTrackModel], Never> = {
        fileManager
            .contents(for: .project(name: project))
            .flatMap(.latest, { (contents) -> SignalProducer<[UVTrackModel], Never> in
                SignalProducer { (observer, _) in
                    var result: [UVTrackModel] = []
                    contents.forEach { fileName in
                        self.fileManager.sampleURL(for: fileName, in: self.project)
                            .on(value: { value in
                                result.append(UVTrackModel(project: self.project, name: fileName, url: value))
                            })
                            .start()
                    }
                    observer.send(value: result)
                }
            })
    }()

    var contents: SignalProducer<[UVTrackModel], Never> {
        assets
//            .on(value: { contents in
//                self.pipelineManager.attach(files: contents)
//            })
//            .map({ (contents) -> [String] in
//                contents.map({ $0.name })
//            })
    }

    private var project: String

//    private lazy var composition: AVCompositionTrack = {
//
//    }()

    // MARK: - Initialization

    init(coordinator: UVCoordinatorType, pipeline: UVPipelineManagerType, fileManager: UVFileManagerType, project name: String) {
        self.coordinator = coordinator
        self.fileManager = fileManager
        pipelineManager = pipeline
        project = name
        fileManager.contents(for: .project(name: project))
            .on(value: { [self] tracks in
                tracks.forEach { track in
                    fileManager.sampleURL(for: track, in: project)
                        .on(value: { _ in

//                            if let audioFile = try? AVAudioFile(forReading: audioURL) {
//                                print(audioFile)
//                            }
////                            print(composition)
//                            AVCompositionTrack
//                            AVComposition(url: AVURLAsset(url: value).url)
                        })
                        .start()
                }
//                .fo
            })
            .start()
//        AVComposition(url: )
    }
}

// MARK: - UVProjectPipelineViewModelType

extension UVProjectPipelineViewModel: UVProjectPipelineViewModelType {

    func addTrack() -> SignalProducer<Void, Never> {
        // MARK: ♻️ REFACTOR LATER ♻️
        SignalProducer { [coordinator, project] (observer, _) in
            coordinator.show(route: .projectTrackRecorder(project: project))
            observer.send(value: ())
        }
    }

    func deleteTrack(at index: Int) -> SignalProducer<Void, Error> {
        assets
            .map { (contents) -> String in contents[index].name }
            .flatMap(.latest, { track -> SignalProducer<Void, Error> in
                SignalProducer { [self] (observer, _) in
                    do {
                        try fileManager.delete(track: track, in: project)
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
            })
    }

    func editTrack(at index: Int) {
        assets
            .map({ $0[index].name })
            .on(value: { [self] track in
                coordinator.show(route: .projectTrackEditor(project: project, track: track))
            })
            .start()
    }

    func didSelect(at index: Int) -> SignalProducer<Void, Never> {
        contents
            .map({ $0[index].name })
            .flatMap(.latest) { track -> SignalProducer<Void, Never> in
                SignalProducer { [self] (observer, _) in
                    coordinator.show(route: .projectTrackEditor(project: project, track: track))
                    observer.send(value: ())
                }
            }
    }

    func play() {
        contents.on(value: { [self] contents in
            pipelineManager.attach(files: contents)
            pipelineManager.play()
        })
        .start()
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
