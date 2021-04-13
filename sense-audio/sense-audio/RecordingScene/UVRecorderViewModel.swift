//
//  UVRecorderViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import Foundation

/**
 Describes an interface for audio recorder view model
 */

protocol UVRecorderViewModelType {
    var audioFileURL: URL? { get }
    
    mutating func startRecording()
    mutating func stopRecording()
    mutating func saveRecord()
    mutating func deleteRecord()
}

struct UVRecorderViewModel {
    private lazy var recorder: VoiceRecorder = {
        let recorder = VoiceRecorder()
        return recorder
    }()
    
    private(set) var audioFileURL: URL?
    
    private lazy var documentsURL: URL? = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()
    
    private lazy var temporaryURL: URL = {
        FileManager.default.temporaryDirectory
    }()
}

extension UVRecorderViewModel: UVRecorderViewModelType {
    
    // MARK: ♻️ REFACTOR LATER ♻️
    mutating func startRecording() {
        let audioURL = temporaryURL.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        try? recorder.record(audioURL)
        audioFileURL = audioURL
    }
    
    mutating func stopRecording() {
        if let audioFileURL = audioFileURL {
            try? FileManager.default.copyItem(at: audioFileURL, to: audioFileURL)
            recorder.stop()
        }
    }
    
    mutating func saveRecord() {
        if let audioFileURL = audioFileURL,
           let destinationFileURL = documentsURL?.appendingPathComponent(audioFileURL.lastPathComponent) {
            try? FileManager.default.copyItem(at: audioFileURL, to: destinationFileURL)
            try? FileManager.default.removeItem(at: audioFileURL)
            self.audioFileURL = destinationFileURL
        }
        //        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
        //           let fileURL = recorder.assetURL {
        //            let newFileURL = directoryURL.appendingPathComponent(fileURL.lastPathComponent)
        ////            print(directoryURL)
        ////            FileManager.default.copy
        //            print(fileURL)
        //            try? FileManager.default.copyItem(at: fileURL, to: newFileURL)
        //            try? FileManager.default.removeItem(at: fileURL)
        //            print(newFileURL)
        ////           let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) {
        ////            self.contents.append(contentsOf: contents.compactMap({ URL(string: $0) }))
        //        }
    }
    
    mutating func deleteRecord() {
        if let audioFileURL = audioFileURL {
            try? FileManager.default.removeItem(at: audioFileURL)
            self.audioFileURL = nil
        }
    }
}
