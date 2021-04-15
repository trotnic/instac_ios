//
//  UVProjectListViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation

protocol UVProjectListViewModelType {
    mutating func numberOfItems() -> Int
    mutating func content(at index: Int) -> String
    
    mutating func create(project name: String)
    mutating func delete(at index: Int)
    
    func didSelect(itemAt index: Int)
}

struct UVProjectListViewModel {
    let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType? = { try? UVFileManager() }()
    private lazy var contents: [String] = { (try? fileManager?.contents(for: .projects)) ?? [] }()
    
    init(coordinator: UVCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension UVProjectListViewModel: UVProjectListViewModelType {
    mutating func numberOfItems() -> Int { contents.count }
    mutating func content(at index: Int) -> String { contents[index] }
    
    mutating func create(project name: String) {
        try? fileManager?.create(project: name)
        contents = (try? fileManager?.contents(for: .projects)) ?? []
    }
    
    mutating func delete(at index: Int) {
        let projectName = contents[index]
        try? fileManager?.delete(project: projectName)
        contents = (try? fileManager?.contents(for: .projects)) ?? []
    }
    
    func didSelect(itemAt index: Int) {
        coordinator.show(route: .projectPipeline)
    }
}
