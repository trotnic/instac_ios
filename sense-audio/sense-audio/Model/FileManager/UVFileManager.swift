//
//  UVFileManager.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation
import ReactiveSwift

///  Defines an interface for interaction with folders in a projects-like way
///
/// - Note: The structure of folders below
/// ```
///
///  |---------|     |--------|       |--------|       |-----|
///  |Documents| --> |Projects| <>--> |Pipeline| <>--> |Track|
///  |---------|     |--------|       |--------|       |-----|
///                         \
///                          \
///                           \
///   |---|                   |-------------|
///   |tmp| - - - - - - - - > |Backing Store|
///   |---|                   |-------------|
///
/// ```

protocol UVFileManagerType {
    func contents(for: UVDirectories) -> SignalProducer<[String], Never>

    func temporaryURL(for fileName: String) -> URL
    func temporizedURL(for temporized: String) -> SignalProducer<URL, Error>
    func sampleURL(for track: String, in project: String) -> SignalProducer<URL, Error>

    mutating func temporize(fileAt url: URL) throws
    mutating func move(fileAt url: URL, to project: String) throws
    mutating func create(project name: String) throws
    mutating func delete(project name: String) throws
    mutating func delete(track: String, in project: String) throws
    
    mutating func rename(project oldName: String, to newName: String) throws
}

enum UVDirectories {
    case projects
    case project(name: String)
    case track(project: String, track: String)
}

// MARK: -
/**
 The UVFileManager object is responsible
 for giving access to folders and paths of their contents,
 create new projects folders and delete existing
 */

struct UVFileManager {
    private let fileManager: FileManager = .default

    init() {
        do {
            try fileManager.createDirectory(at: Constants.projectsFolderURL, withIntermediateDirectories: true, attributes: nil)
            try fileManager.createDirectory(at: Constants.backingStoreFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assert(false, "FileManager must initialize directories hierarchy, but happened error: \(error)")
        }
    }

    fileprivate struct Constants {
        static let projectsFolderName = "Projects"
        static let backingStoreFolderName = "BStore"
        static let projectsFolderURL: URL = {
            // MARK: ♻️ REFACTOR LATER ♻️
            FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(projectsFolderName)
        }()
        static let backingStoreFolderURL: URL = {
            FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(backingStoreFolderName)
        }()
        static let temporaryFolderURL: URL = { FileManager.default.temporaryDirectory }()
    }
}

extension UVFileManager: UVFileManagerType {
    func contents(for: UVDirectories) -> SignalProducer<[String], Never> {
        SignalProducer { (observer, _) in
            switch `for` {
            case let .project(name):
                if let contents = try? fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL
                                                                        .appendingPathComponent(name).path) {
                    observer.send(value: contents)
                }
            case .projects:
                if let contents = try? fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL.path) {
                    observer.send(value: contents)
                }
            case let .track(project, track):
                if let contents = try? fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL
                                                                        .appendingPathComponent(project)
                                                                        .appendingPathComponent(track).path) {
                    observer.send(value: contents)
                }
            }
        }
    }

    /**
     This method provides a URL for a file in the __/tmp__ folder
     
     */

    func temporaryURL(for fileName: String) -> URL {
        Constants.temporaryFolderURL.appendingPathComponent(fileName)
    }

    /**
     This method provides a URL for a file in the __/Backing Store__ folder
     
     */

    func temporizedURL(for temporized: String) -> SignalProducer<URL, Error> {
        SignalProducer { (observer, _) in
            do {
                if let url = try fileManager.contentsOfDirectory(atPath: Constants.backingStoreFolderURL.path)
                    .compactMap({ URL(string: $0) })
                    .filter({ $0.lastPathComponent == temporized })
                    .first {
                    observer.send(value: Constants.backingStoreFolderURL.appendingPathComponent(url.path))
                }
            } catch {
                observer.send(error: error)
            }
        }
    }

    func sampleURL(for track: String, in project: String) -> SignalProducer<URL, Error> {
        SignalProducer { (observer, _) in
            let result = Constants.projectsFolderURL.appendingPathComponent(project)
                .appendingPathComponent(track)

            observer.send(value: result)
        }
    }

    mutating func create(project name: String) throws {
        // MARK: ♻️ REFACTOR LATER ♻️
        // checking for existing directories

        let fileUrl = Constants.projectsFolderURL.appendingPathComponent(name)
        try fileManager.createDirectory(at: fileUrl, withIntermediateDirectories: true, attributes: nil)
    }

    mutating func delete(project name: String) throws {
        // MARK: ♻️ REFACTOR LATER ♻️
        try fileManager.removeItem(at: Constants.projectsFolderURL.appendingPathComponent(name))
    }

    mutating func temporize(fileAt url: URL) throws {
        let destinationFileURL = Constants.backingStoreFolderURL
            .appendingPathComponent(url.lastPathComponent)

        try fileManager.copyItem(at: url, to: destinationFileURL)
        try fileManager.removeItem(at: url)
    }

    mutating func move(fileAt url: URL, to project: String) throws {
        let destinationFileURL = Constants.projectsFolderURL
            .appendingPathComponent(project)
            .appendingPathComponent(url.lastPathComponent)

        try fileManager.copyItem(at: url, to: destinationFileURL)
        try fileManager.removeItem(at: url)
    }

    mutating func delete(track: String, in project: String) throws {
        let destinationFileURL = Constants.projectsFolderURL
            .appendingPathComponent(project)
            .appendingPathComponent(track)

        try fileManager.removeItem(at: destinationFileURL)
    }
    
    func rename(project oldName: String, to newName: String) throws {
        let oldURL = Constants.projectsFolderURL.appendingPathComponent(oldName)
        let newURL = Constants.projectsFolderURL.appendingPathComponent(newName)
        
        try fileManager.moveItem(at: oldURL, to: newURL)
    }
}
