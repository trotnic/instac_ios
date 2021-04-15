//
//  UVCoordinatorFactory.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      15.04.21
//

import UIKit

/**
 This type is responsible
 for creating presentation blocks
 and fill them with dependencies required
 */

struct UVCoordinatorFactory {
    func block(for route: Route, coordinator: UVCoordinatorType) -> UIViewController {
        switch route {
        case .projectList:
            let listViewModel = UVProjectListViewModel(coordinator: coordinator)
            let controller = UVProjectListViewController(list: listViewModel)
            return UINavigationController(rootViewController: controller)
        case .projectPipeline:
            let pipeline = UVPipelineManager()
            let fileManager = try! UVFileManager()
            let pipeViewModel = UVProjectPipelineViewModel(coordinator: coordinator, pipeline: pipeline, fileManager: fileManager)
            let controller = UVProjectPipelineViewController(pipeline: pipeViewModel)
            return UINavigationController(rootViewController: controller)
        case let .projectTrack(project):
            let recorder = VoiceRecorder()
            let fileManager = try! UVFileManager()
            let recorderViewModel = UVRecorderViewModel(recorder: recorder, fileManager: fileManager, project: project)
            let playerViewModel = UVPlayerViewModel()
            let controller = UVProjectTrackViewController(recorder: recorderViewModel, player: playerViewModel)
            return UINavigationController(rootViewController: controller)
        }
    }
}
