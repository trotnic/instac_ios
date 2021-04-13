//
//  AppDelegate.swift
//
//  Project: sense-audio
//
//  Author: Uladzislau Volchyk
//  On: 26.01.21
//
//

import UIKit

// MARK: ⚠️ DEVELOP ZONE ⚠️
import AVFoundation

extension AVAudioSession {
    static var shared: AVAudioSession { sharedInstance() }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) { (_) in }
        
        let session = AVAudioSession.shared
        
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.allowBluetooth])
            
        } catch let error {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

