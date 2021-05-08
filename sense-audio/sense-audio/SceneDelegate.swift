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

    var window: UIWindow?
    private var coordinator: UVCoordinatorType?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // MARK: ⚠️ DEVELOP ZONE ⚠️
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        coordinator = UVCoordinator(navigation: navigationController, factory: UVCoordinatorFactory())

//        coordinator?.show(route: .projectList)
        coordinator?.show(route: .projectPipeline(project: "123"))
        window?.makeKeyAndVisible()
    }

}
