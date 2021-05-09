//
//  UVDataManager.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import Foundation
import CoreData

final class UVDataManager {

    var persistentContainer: NSPersistentContainer

    init(completionClosure: @escaping () -> Void) {
        persistentContainer = NSPersistentContainer(name: "TrackModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
}
