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
    var time: MutableProperty<String> { get }
    var audioFileURL: Signal<URL?, Never> { get }
    var playbackEnd: Signal<Void, Never> { get }
    
    var audioFileName: String? { get }

    func startRecording()
    func stopRecording()
    func playRecord()
    func saveRecord()
    func deleteRecord()
}

final class UVRecorderViewModel {
    
    var audioFileURL: Signal<URL?, Never> { _audioFileURL }
    private let (_audioFileURL, _audioFileURLObserver) = Signal<URL?, Never>.pipe()
    
    var playbackEnd: Signal<Void, Never> { _playbackEnd }
    private let (_playbackEnd, _playbackEndObserver) = Signal<Void, Never>.pipe()

    let time: MutableProperty<String> = MutableProperty("00:00")

    private var recorder: UVVoiceRecorder
    private var fileManager: UVFileManagerType
    private let coordinator: UVCoordinatorType
    private let project: UVProjectModel

    private(set) var audioFileName: String?

    init(coordinator: UVCoordinatorType, recorder: UVVoiceRecorder, project: UVProjectModel, fileManager: UVFileManagerType = UVFileManager()) {
        self.coordinator = coordinator
        self.recorder = recorder
        self.fileManager = fileManager
        self.project = project
        
        setupBindings()
    }
}

// MARK: - Public interface

// MARK: - Private interface

private extension UVRecorderViewModel {
    func setupBindings() {
        recorder.playbackTime
            .observe(on: QueueScheduler.main)
            .observeValues({ playbackTime in
                self.time.value = .formatted(time: playbackTime)
            })
        
        recorder.playbackEnd
            .observe(on: QueueScheduler.main)
            .observeValues {
                self._playbackEndObserver.send(value: ())
            }
        
        
    }
}

// MARK: - UVRecorderViewModelType

extension UVRecorderViewModel: UVRecorderViewModelType {

    // MARK: ♻️ REFACTOR LATER ♻️
    func startRecording() {
        do {
            let fileName = "\(Date().timeIntervalSince1970).caf"
            let audioURL = fileManager.temporaryURL(for: fileName)
            try recorder.record(audioURL)
            audioFileName = fileName
        } catch {
            // MARK: ♻️ REFACTOR LATER ♻️
            print(error)
//            observer.send(error: error)
        }
    }

    func stopRecording() {
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
                    fileManager.temporizedURL(for: fileURL.lastPathComponent)
                        .on(value: { fileURL in
                            _audioFileURLObserver.send(value: fileURL)
                        })
                        .start()
                    observer.send(value: ())
                } catch {
                    observer.send(error: error)
                }
            }
        }
        .start()
    }
    
    func playRecord() {
        guard let fileName = audioFileName else {
            return
        }
        fileManager.temporizedURL(for: fileName)
            .on(value: { fileURL in
                self.recorder.play(fileURL)
            })
            .start()
    }

    func saveRecord() {
//        SignalProducer<String?, Error> { [self] (observer, _) in
//            observer.send(value: audioFileName)
//        }
//        .skipNil()
//        .flatMap(.latest, { self.fileManager.temporizedURL(for: $0) })
//        .flatMap(.latest) { [self] (fileURL) -> SignalProducer<URL, Error> in
//            SignalProducer { (observer, _) in
//                do {
//                    try fileManager.move(fileAt: fileURL, to: project)
//                    observer.send(value: fileURL)
//                } catch {
//                    observer.send(error: error)
//                }
//            }
//        }
//        .on(value: { [self] url in
//            // MARK: ♻️ REFACTOR LATER ♻️
//            /**
//             store in CoreData
//             */
////            let track = UVTrackModel(project: project, name: url.lastPathComponent, url: url)
////            coordinator.show(route: .projectTrackEditor(project: project, track: track))
//        })
//        .start()

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

    func deleteRecord() {
        guard let audioFileName = audioFileName else {
            return
        }
        // MARK: ♻️ REFACTOR LATER ♻️
        try? fileManager.delete(temporized: audioFileName)
        self.audioFileName = nil
    }
}
