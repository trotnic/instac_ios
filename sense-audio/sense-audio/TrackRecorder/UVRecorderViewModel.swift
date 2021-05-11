//
//  UVRecorderViewModel.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import Foundation
import ReactiveSwift

/**
 Describes an interface
 for audio recorder view model
 */

protocol UVRecorderViewModelType {
    var audioFileName: String? { get }

    func startRecording() -> SignalProducer<Void, Error>
    func stopRecording() -> SignalProducer<Void, Error>
    func saveRecord()
    func deleteRecord() -> SignalProducer<Void, Error>
}

final class UVRecorderViewModel {

    private var recorder: VoiceRecorder
    private var fileManager: UVFileManagerType
    private let coordinator: UVCoordinatorType
    // MARK: 🗑 DELETE LATER 🗑
    private let project: String

    private(set) var audioFileName: String?

    init(coordinator: UVCoordinatorType, recorder: VoiceRecorder, project name: String, fileManager: UVFileManagerType = UVFileManager()) {
        self.coordinator = coordinator
        self.recorder = recorder
        self.fileManager = fileManager
        project = name
    }
}

extension UVRecorderViewModel: UVRecorderViewModelType {

    // MARK: ♻️ REFACTOR LATER ♻️
    func startRecording() -> SignalProducer<Void, Error> {
        SignalProducer { [self] (observer, _) in
            do {
                let fileName = "\(Date().timeIntervalSince1970).caf"
                let audioURL = fileManager.temporaryURL(for: fileName)
                try recorder.record(audioURL)
                audioFileName = fileName
                observer.send(value: ())
            } catch {
                observer.send(error: error)
            }
        }

    }

    func stopRecording() -> SignalProducer<Void, Error> {
        SignalProducer<String?, Error> { [self] (observer, _) in
            observer.send(value: audioFileName)
        }
        .skipNil()
        .map({ self.fileManager.temporaryURL(for: $0) })
        .flatMap(.latest) { [self] (fileURL) -> SignalProducer<Void, Error> in
            SignalProducer { (observer, _) in
                do {
                    recorder.stop()
                    try fileManager.temporize(fileAt: fileURL)
                    observer.send(value: ())
                } catch {
                    observer.send(error: error)
                }
            }
        }
    }

    func saveRecord() {
        SignalProducer<String?, Error> { [self] (observer, _) in
            observer.send(value: audioFileName)
        }
        .skipNil()
        .flatMap(.latest, { self.fileManager.temporizedURL(for: $0) })
        .flatMap(.latest) { [self] (fileURL) -> SignalProducer<URL, Error> in
            SignalProducer { (observer, _) in
                do {
                    try fileManager.move(fileAt: fileURL, to: project)
                    observer.send(value: fileURL)
                } catch {
                    observer.send(error: error)
                }
            }
        }
        .on(value: { [self] url in
            // MARK: ♻️ REFACTOR LATER ♻️
            /**
             store in CoreData
             */
//            let track = UVTrackModel(project: project, name: url.lastPathComponent, url: url)
//            coordinator.show(route: .projectTrackEditor(project: project, track: track))
        })
        .start()

        // MARK: ♻️ REFACTOR LATER ♻️
//        if let audioFileURL = audioFileURL {
//            try?
//        }
//        if let audioFileURL = audioFileURL,
//           let destinationFileURL = documentsURL?.appendingPathComponent(audioFileURL.lastPathComponent) {
//            try? FileManager.default.copyItem(at: audioFileURL, to: destinationFileURL)
//            try? FileManager.default.removeItem(at: audioFileURL)
//            self.audioFileURL = destinationFileURL
//        }
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

    func deleteRecord() -> SignalProducer<Void, Error> {
        SignalProducer<String?, Error> { [self] (observer, _) in
            observer.send(value: audioFileName)
        }
        .skipNil()
        .flatMap(.latest) { self.fileManager.temporizedURL(for: $0) }
        .flatMap(.latest) { [self] (fileURL) -> SignalProducer<Void, Error> in
            SignalProducer { (observer, _) in
                do {
                    // MARK: ♻️ REFACTOR LATER ♻️
                    try FileManager.default.removeItem(at: fileURL)
                    audioFileName = nil
                    observer.send(value: ())
                } catch {
                    observer.send(error: error)
                }
            }
        }
    }
}
