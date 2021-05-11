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
            let controller = UVProjectListViewController.instantiate(listViewModel)
            return controller
        case let .projectPipeline(project):
            let pipeline = UVPipelineManager()
            let fileManager = UVFileManager()
            let pipelineViewModel = UVProjectPipelineViewModel(coordinator: coordinator, pipeline: pipeline, fileManager: fileManager, project: project)
            let controller = UVProjectPipelineViewController.instantiate(pipelineViewModel)
            return controller
        case let .projectTrackRecorder(project):
            let recorder = VoiceRecorder()
            let recorderViewModel = UVRecorderViewModel(coordinator: coordinator, recorder: recorder, project: project)
            let playerViewModel = UVPlayerViewModel()
            let controller = UVTrackRecorderViewController(recorder: recorderViewModel, player: playerViewModel)
            return controller
        case let .projectTrackEditor(project, track):
            let editor = UVEditor(track: track)
            let editorViewModel = UVTrackEditorViewModel(coordinator: coordinator, editor: editor, project: project, track: track)
            let controller = UVTrackEditorViewController.instantiate(editorViewModel)
            return controller
        }
    }
}
