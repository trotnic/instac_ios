//
//  UVProjectPipelineViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation
import AVFoundation
import ReactiveSwift

protocol UVProjectPipelineViewModelType {
    var contents: SignalProducer<[String], Never> { get }
    
    func addTrack() -> SignalProducer<Void, Never>
    func delete(at index: Int) -> SignalProducer<Void, Error>
}

final class UVProjectPipelineViewModel {

    let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType
    private let pipelineManager: UVPipelineManagerType
    var contents: SignalProducer<[String], Never> {
        fileManager
            .contents(for: .project(name: project))
            .on(value: { contents in
                let assets = contents.compactMap({ (path) -> URL? in
                    URL(string: path)
                })
                .map { (url) -> AVAsset in
                    AVAsset(url: url)
                }
            })
    }
    private var project: String

    init(coordinator: UVCoordinatorType,
         pipeline: UVPipelineManagerType,
         fileManager: UVFileManagerType,
         project name: String) {
        self.coordinator = coordinator
        self.fileManager = fileManager
        pipelineManager = pipeline
        project = name
    }
}

extension UVProjectPipelineViewModel: UVProjectPipelineViewModelType {

    func addTrack() -> SignalProducer<Void, Never> {
        // MARK: ♻️ REFACTOR LATER ♻️
        SignalProducer { [coordinator, project] (observer, _) in
            coordinator.show(route: .projectTrack(project: project))
            observer.send(value: ())
        }
    }

    func delete(at index: Int) -> SignalProducer<Void, Error> {
        contents
            .map { (contents) -> String in contents[index] }
            .flatMap(.latest, { (track) -> SignalProducer<Void, Error> in
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
}
