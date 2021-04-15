//
//  UVProjectPipelineViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation


protocol UVProjectPipelineViewModelType {
    mutating func numberOfElements() -> Int
    mutating func content(at index: Int) -> String
    
    func addTrack()
}

struct UVProjectPipelineViewModel {
    
    let coordinator: UVCoordinatorType
    private var fileManager: UVFileManagerType
    private let pipelineManager: UVPipelineManagerType
    private lazy var contents: [String] = {
        (try? fileManager.contents(for: .project(name: "lolkek"))) ?? []
    }()
    
    init(coordinator: UVCoordinatorType, pipeline: UVPipelineManagerType, fileManager: UVFileManagerType) {
        self.coordinator = coordinator
        self.fileManager = fileManager
        pipelineManager = pipeline
    }
}

extension UVProjectPipelineViewModel: UVProjectPipelineViewModelType {
    mutating func numberOfElements() -> Int { contents.count }
    
    mutating func content(at index: Int) -> String { contents[index] }
    
    func addTrack() {
        // MARK: ♻️ REFACTOR LATER ♻️
        coordinator.show(route: .projectTrack(project: "lolkek"))
    }
}
