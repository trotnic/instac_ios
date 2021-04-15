//
//  SceneDelegate.swift
//
//  Project: sense-audio
//
//  Author: Uladzislau Volchyk
//  On: 26.01.21
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var coordinator: UVCoordinatorType?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // MARK: ⚠️ DEVELOP ZONE ⚠️
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        coordinator = UVCoordinator(window: window, factory: UVCoordinatorFactory())
        coordinator?.start()
        coordinator?.show(route: .projectList)
    }

}

