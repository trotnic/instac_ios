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
    func rename(at index: Int, with name: String)
    
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
        dataManager.getProjects()
            .observe(on: QueueScheduler.main)
            .on(value: { contents in
                self._contents.value = contents
            })
            .start()
    }

    func create(project name: String) {
        dataManager.create(.project(UVProjectModel(name: name)))
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
    
    func rename(at index: Int, with name: String) {
        var project = _contents.value[index]
        let oldName = project.name
        project.name = name
        dataManager.update(.project(project))
            .on(value: { [self] in
                do {
                    try fileManager.rename(project: oldName, to: name)
                    requestContents()
                } catch {
                    // MARK: ♻️ REFACTOR LATER ♻️
                    print(error)
                }
            })
            .start()
    }

    func didSelect(itemAt index: Int) {
        let project = _contents.value[index]
        coordinator.show(route: .projectPipeline(project: project))
    }
}
