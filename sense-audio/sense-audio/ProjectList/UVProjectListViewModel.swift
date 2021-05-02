//
//  UVProjectListViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation
import ReactiveSwift

protocol UVProjectListViewModelType {
    var contents: SignalProducer<[String], Never> { get }

    mutating func create(project name: String) -> SignalProducer<Void, Error>
    mutating func delete(at index: Int) -> SignalProducer<Void, Error>

    mutating func didSelect(itemAt index: Int)
}

final class UVProjectListViewModel {

    let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType = UVFileManager()

    lazy var contents: SignalProducer<[String], Never> = { fileManager.contents(for: .projects) }()

    init(coordinator: UVCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension UVProjectListViewModel: UVProjectListViewModelType {

    func create(project name: String) -> SignalProducer<Void, Error> {
        SignalProducer { (observer, _) in
            do {
                try self.fileManager.create(project: name)
                observer.send(value: ())
            } catch {
                observer.send(error: error)
            }
        }
    }

    func delete(at index: Int) -> SignalProducer<Void, Error> {
        contents
            .map { (contents) -> String in
                contents[index]
            }
            .flatMap(.merge, { (projectName) -> SignalProducer<Void, Error> in
                SignalProducer { (observer, _) in
                    do {
                        try self.fileManager.delete(project: projectName)
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
            })
    }

    func didSelect(itemAt index: Int) {
        contents
            .map { (contents) -> String in contents[index] }
            .on(value: { self.coordinator.show(route: .projectPipeline(project: $0)) })
            .start()
    }
}
