//
//  UVRecordListPresenter.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import Foundation

protocol UVRecordListType {
    var numberOfItems: Int { get }
    func path(_ at: Int) -> String
    
    func delete(_ at: Int)
}

class UVRecordListPresenter: UVRecordListType {
    
    private lazy var contents: [URL] = {
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) {
            return contents.compactMap({ URL(string: $0) })
        }
        return []
    }()
    
    var numberOfItems: Int { contents.count }
    
    func path(_ at: Int) -> String { contents[at].path }
    
    func delete(_ at: Int) {
        
    }
}
