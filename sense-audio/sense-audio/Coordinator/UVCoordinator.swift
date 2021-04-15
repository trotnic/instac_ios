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
    func start()
}

enum Route {
    case projectList
    case projectPipeline
    case projectTrack(project: String)
}

struct UVCoordinator {
    let window: UIWindow
    private let factory: UVCoordinatorFactory
    init(window: UIWindow, factory: UVCoordinatorFactory) {
        self.window = window
        self.factory = factory
    }
}

extension UVCoordinator: UVCoordinatorType {
    func show(route: Route) {
        window.rootViewController = factory.block(for: route, coordinator: self)
//        switch route {
//        case .projectList:
//            window.ro
//            window.rootViewController = UINavigationController(rootViewController: UVProjectListViewController())
//        case .projectPipeline:
//
//            break
//        case .projectTrack:
//            break
//        }
        
    }
    
    func start() {
        window.makeKeyAndVisible()
    }
}
