//
//  UVCoordinator.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      15.04.21
//

import UIKit

protocol UVCoordinatorType {
    func show(route: Route)
    func back()
}

enum Route {
    case projectList
    case projectPipeline(project: UVProjectModel)
    case projectTrackRecorder(project: UVProjectModel)
    case projectTrackEditor(project: UVProjectModel, track: UVTrackModel)
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

    func back() {
        navigationController.popViewController(animated: true)
    }
}
