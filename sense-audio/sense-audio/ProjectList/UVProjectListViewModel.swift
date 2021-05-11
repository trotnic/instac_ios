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
    var contents: Signal<[String], Never> { get }
    
    func requestContents()
    func create(project name: String)
    func delete(at index: Int)
    
    func didSelect(itemAt index: Int)
}

final class UVProjectListViewModel {
    
    var contents: Signal<[String], Never> { _contents.signal.map({ content in content.map({ $0.name }) }) }

    private let coordinator: UVCoordinatorType
    
    private let dataManager: UVDataManager = .shared
    private var fileManager: UVFileManagerType = UVFileManager()
    private let _contents: MutableProperty<[UVProjectModel]> = MutableProperty([])

    init(coordinator: UVCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension UVProjectListViewModel: UVProjectListViewModelType {
    
    func requestContents() {
        dataManager.get(.project(nil))
            .observe(on: UIScheduler())
            .on(value: { contents in
                guard let contents = contents as? [UVProjectModel] else {
                    return
                }
                self._contents.value = contents
            })
            .start()
    }

    func create(project name: String) {
        dataManager.create(.project(UVProjectModel(name: name)))
            .observe(on: UIScheduler())
            .on(value: { [self] in
                do {
                    try fileManager.create(project: name)
                    requestContents()
                } catch {
                    // MARK: ♻️ REFACTOR LATER ♻️
                    print(error)
                }
            })
            .start()
    }

    func delete(at index: Int) {
        let project = _contents.value[index]
        dataManager.delete(.project(project))
            .on(value: { [self] in
                do {
                    try fileManager.delete(project: project.name)
                    requestContents()
                } catch {
                    // MARK: ♻️ REFACTOR LATER ♻️
                    print(error)
                }
            })
            .start()
    }

    func didSelect(itemAt index: Int) {
        
//        contents
//            .map { (contents) -> String in contents[index] }
//            .on(value: { self.coordinator.show(route: .projectPipeline(project: $0)) })
//            .start()
    }
}
