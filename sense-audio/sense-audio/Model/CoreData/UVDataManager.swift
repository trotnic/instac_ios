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
    func getProjects() -> SignalProducer<[UVProjectModel], Error> {
        SignalProducer { (observer, _) in
            self.persistentContainer.performBackgroundTask { context in
                let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                do {
                    let rawResult = try context.fetch(request)
                    let result = rawResult.compactMap { UVProjectModel($0) }
                    observer.send(value: result)
                } catch {
                    observer.send(error: error)
                }
            }
        }
    }

    func getTracks(for project: UUID) -> SignalProducer<[UVTrackModel], Error> {
        SignalProducer { (observer, _) in
            self.persistentContainer.performBackgroundTask { context in
                let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                do {
                    let rawResult = try context.fetch(request)
                    let result = rawResult.flatMap { project_model -> [UVTrackModel] in
                        if let tracks = project_model.tracks?.allObjects as? [CDTrack] {
                            return tracks.map({ UVTrackModel($0) })
                        }
                        return []
                    }
                    observer.send(value: result)
                } catch {
                    observer.send(error: error)
                }
            }
        }
    }

//    func get(_ entity: EntityType) -> SignalProducer<[Any], Error> {
//        SignalProducer { [self] (observer, _) in
//            switch entity {
//            case .project(_):
//                persistentContainer.performBackgroundTask { context in
//                    let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
//                    do {
//                        let rawResult = try context.fetch(request)
//                        let result = rawResult.compactMap { project_model -> UVProjectModel? in
//                            if let name = project_model.name,
//                               let uuid = project_model.id {
//                                return UVProjectModel(id: uuid, name: name)
//                            }
//                            return nil
//                        }
//                        observer.send(value: result)
//                    } catch {
//                        observer.send(error: error)
//                    }
//                }
//                break
//            case .track(_):
//                // MARK: ♻️ REFACTOR LATER ♻️
//                break
//            }
//        }
//    }

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
                        project_model.attach(project)
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
                    let request: NSFetchRequest<CDProject> = CDProject.fetchRequest()
                    do {
                        let project_models = try context.fetch(request)

                        project_models.forEach { project_model in
                            let track_model = CDTrack(context: context)
                            track_model.attach(track)
                            project_model.addToTracks(track_model)
                        }
                        try context.save()
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
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
                guard let track = track else {
                    observer.sendCompleted()
                    return
                }
                persistentContainer.performBackgroundTask { context in
                    let request: NSFetchRequest<CDTrack> = CDTrack.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", track.id.uuidString)
                    do {
                        let models = try context.fetch(request)
                        models.forEach { $0.attach(track) }
                        try context.save()
                        observer.send(value: ())
                    } catch {
                        observer.send(error: error)
                    }
                }
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
            case .track:
                break
            }
        }
    }
}

// MARK: - Private interface

private extension UVDataManager {

}
