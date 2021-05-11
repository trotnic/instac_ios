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
    var contents: Signal<[String], Error> { get }
    
//    var contents: SignalProducer<[String], Never> { get }

    mutating func requestContents()
    mutating func create(project name: String)
    mutating func delete(at index: Int)

    mutating func didSelect(itemAt index: Int)
}

final class UVProjectListViewModel {
    
    var contents: Signal<[String], Error> { _contents }

    private let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType = UVFileManager()
    private let (_contents, _contentsObserver) = Signal<[String], Error>.pipe()

//    lazy var contents: SignalProducer<[String], Never> = { fileManager.contents(for: .projects) }()

    init(coordinator: UVCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension UVProjectListViewModel: UVProjectListViewModelType {
    
    func requestContents() {
        fileManager.contents(for: .projects)
            .on(value: { contents in
                self._contentsObserver.send(value: contents)
            })
            .start()
    }

    func create(project name: String) {
        do {
            try fileManager.create(project: name)
            requestContents()
        } catch {
            _contentsObserver.send(error: error)
        }
//        SignalProducer { (observer, _) in
//            do {
//                try self.fileManager.create(project: name)
//                observer.send(value: ())
//            } catch {
//                observer.send(error: error)
//            }
//        }
    }

    func delete(at index: Int) {
//        contents
//            .map { (contents) -> String in
//                contents[index]
//            }
//            .flatMap(.merge, { (projectName) -> SignalProducer<Void, Error> in
//                SignalProducer { (observer, _) in
//                    do {
//                        try self.fileManager.delete(project: projectName)
//                        observer.send(value: ())
//                    } catch {
//                        observer.send(error: error)
//                    }
//                }
//            })
    }

    func didSelect(itemAt index: Int) {
//        contents
//            .map { (contents) -> String in contents[index] }
//            .on(value: { self.coordinator.show(route: .projectPipeline(project: $0)) })
//            .start()
    }
}
