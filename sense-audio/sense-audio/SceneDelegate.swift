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


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // MARK: ⚠️ DEVELOP ZONE ⚠️
        guard let scene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: scene)
        let navigationController = UINavigationController(rootViewController: UVRecordingListViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

