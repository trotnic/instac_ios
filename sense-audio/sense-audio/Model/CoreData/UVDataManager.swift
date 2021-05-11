//
//  UVDataManager.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import CoreData
import ReactiveSwift

final class UVDataManager {

    enum EntityType {
        case project(UVProjectModel?)
        case track(UVTrackModel?)
    }
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    var newBackgroundContext: NSManagedObjectContext { persistentContainer.newBackgroundContext() }
    
    private let persistentContainer: NSPersistentContainer
    
    static let shared: UVDataManager = UVDataManager()

    init(completion: ((Error?) -> Void)? = nil) {
        persistentContainer = NSPersistentContainer(name: "TrackModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            
            completion?(error)
        }
    }
}

// MARK: - Public interface

extension UVDataManager {
    func get(_ entity: EntityType) -> SignalProducer<[Any], Error> {
        SignalProducer { [self] (observer, _) in
            switch entity {
            case .project(_):
                persistentContainer.performBackgroundTask { context in
                    let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                    do {
                        let rawResult = try context.fetch(request)
                        let result = rawResult.compactMap { project_model -> UVProjectModel? in
                            if let name = project_model.name,
                               let uuid = project_model.id {
                                return UVProjectModel(id: uuid, name: name)
                            }
                            return nil
                        }
                        observer.send(value: result)
                    } catch {
                        observer.send(error: error)
                    }
                }
                break
            case .track(_):
                break
            }
        }
    }
    
    func create(_ entity: EntityType) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            switch entity {
            case .project(let project):
                guard let project = project else {
                    observer.sendCompleted()
                    return
                }
                persistentContainer.performBackgroundTask { context in
                    do {
                        let project_model = CDProject(context: context)
                        project_model.name = project.name
                        project_model.tracks = NSSet()
                        project_model.id = project.id
                        try context.save()
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
            case .track(let track):
                guard let track = track else {
                    observer.sendCompleted()
                    return
                }
                persistentContainer.performBackgroundTask { context in
                    let track_model = CDTrack(context: context)
//                    track_model.isOn_EQ = track.isOn.value
//                    track_model.globalGain_EQ = track.
                }
            }
        }
    }
    
    func update(_ entity: EntityType) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            switch entity {
            case .project(let project):
                guard let project = project else {
                    observer.sendCompleted()
                    return
                }
                persistentContainer.performBackgroundTask { context in
                    let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", project.id.uuidString)
                    do {
                        // MARK: ♻️ REFACTOR LATER ♻️
                        let models = try context.fetch(request)
                        models.forEach { project_model in
                            project_model.name = project.name
                        }
                        try context.save()
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
            case .track(let track):
                break
            }
        }
    }
    
    func delete(_ entity: EntityType) -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            switch entity {
            case .project(let project):
                guard let project = project else {
                    observer.sendCompleted()
                    return
                }
                persistentContainer.performBackgroundTask { context in
                    let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", project.id.uuidString)
                    do {
                        let models = try context.fetch(request)
                        models.forEach({ context.delete($0) })
                        try context.save()
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
            case .track(let track):
                break
            }
        }
    }
}

// MARK: - Private interface

private extension UVDataManager {
    
}
