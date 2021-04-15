//
//  UVFileManager.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import Foundation


///  Defines an interface for interaction with folders in a projects-like way
///
/// - Note: The structure of folders below
/// ```
///
/// |--------|         |----------------|         |-------------|
/// |Projects| <>----> |Project Pipeline| <>----> |Project Track|
/// |--------|         |----------------|         |-------------|
///
/// ```

protocol UVFileManagerType {
    mutating func contents(for: UVDirectories) throws -> [String]
    
    mutating func move(file at: URL, to project: String) throws
    mutating func create(project name: String) throws
    mutating func delete(project name: String) throws
//    mutating func create(in: UVDirectories, name: String) throws
//    mutating func delete(in: UVDirectories, name: String) throws
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
    private lazy var fileManager: FileManager = { .default }()
    
    init() throws {
        try fileManager.createDirectory(at: Constants.projectsFolderURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    fileprivate struct Constants {
        static let projectsFolderName = "Projects"
        static let projectsFolderURL: URL = {
            // MARK: ♻️ REFACTOR LATER ♻️
            FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(projectsFolderName)
        }()
    }
}

extension UVFileManager: UVFileManagerType {
    mutating func contents(for: UVDirectories) throws -> [String] {
        switch `for` {
        case let .project(name):
            return try fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL
                                                        .appendingPathComponent(name).path)
        case let .track(project, track):
            return try fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL
                                                        .appendingPathComponent(project)
                                                        .appendingPathComponent(track).path)
        case .projects:
            return try fileManager.contentsOfDirectory(atPath: Constants.projectsFolderURL.path)
        }
    }
    
    mutating func create(project name: String) throws {
        // MARK: ♻️ REFACTOR LATER ♻️
        // checking for existing directories
        try fileManager.createDirectory(at: Constants.projectsFolderURL.appendingPathComponent(name), withIntermediateDirectories: true, attributes: nil)
    }
    
    mutating func delete(project name: String) throws {
        // MARK: ♻️ REFACTOR LATER ♻️
        try fileManager.removeItem(at: Constants.projectsFolderURL.appendingPathComponent(name))
    }

    mutating func move(file at: URL, to project: String) throws {
        let destinationFileURL = Constants.projectsFolderURL
            .appendingPathComponent(project)
            .appendingPathComponent(at.lastPathComponent)
        
        try fileManager.copyItem(at: at, to: destinationFileURL)
        try fileManager.removeItem(at: at)
    }
}
