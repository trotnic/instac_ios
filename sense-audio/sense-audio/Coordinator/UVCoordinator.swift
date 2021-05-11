//
//  UVCoordinator.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      15.04.21
//

import UIKit

// MARK: ♻️ REFACTOR LATER ♻️

protocol UVCoordinatorType {
    func show(route: Route)
}

enum Route {
    case projectList
    case projectPipeline(project: UVProjectModel)
    case projectTrackRecorder(project: String)
    case projectTrackEditor(project: String, track: UVTrackModel)
}

struct UVCoordinator {
    let navigationController: UINavigationController
    private let factory: UVCoordinatorFactory
    init(navigation controller: UINavigationController, factory: UVCoordinatorFactory) {
        navigationController = controller
        self.factory = factory
    }
}

extension UVCoordinator: UVCoordinatorType {
    func show(route: Route) {

        navigationController.pushViewController(factory.block(for: route, coordinator: self), animated: true)
    }
}
