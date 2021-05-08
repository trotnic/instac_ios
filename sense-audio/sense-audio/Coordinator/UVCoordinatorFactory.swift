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
            let dataSource = UVProjectListDatasource()
            let controller = UVProjectListViewController(list: listViewModel, data: dataSource)
            return controller
        case let .projectPipeline(project):
            let pipeline = UVPipelineManager()
            let fileManager = UVFileManager()
            let pipeViewModel = UVProjectPipelineViewModel(coordinator: coordinator, pipeline: pipeline, fileManager: fileManager, project: project)
            let controller = UVProjectPipelineViewController(pipeline: pipeViewModel)
            return controller
        case let .projectTrackRecorder(project):
            let fileManager = UVFileManager()
            let recorder = VoiceRecorder()
            let recorderViewModel = UVRecorderViewModel(coordinator: coordinator, recorder: recorder, project: project)
            let playerViewModel = UVPlayerViewModel(fileManager: fileManager)
            let controller = UVTrackRecorderViewController(recorder: recorderViewModel, player: playerViewModel)
            return controller
        case let .projectTrackEditor(project, track):
            let editor = UVEditor()
            let editorViewModel = UVTrackEditorViewModel(coordinator: coordinator, editor: editor, project: project, track: track)
            let controller = UVTrackEditorViewController(editor: editorViewModel)
            return controller
        }
    }
}
