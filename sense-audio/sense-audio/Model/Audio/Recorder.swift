//
//  Recorder.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      31.03.21
//

import AVFoundation

protocol RecorderType {
    func record(_ fileURL: URL) throws
    func pause()
    func resume() throws
    func stop()
}

final class VoiceRecorder {

    // MARK: - Private Props

    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.attach(playerNode)
        engine.attach(mixerNode)

        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        engine.connect(inputNode, to: mixerNode, format: inputFormat)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: inputFormat)

        return engine
    }()

    private var mixerNode: AVAudioMixerNode = {
        AVAudioMixerNode()
    }()

    private var playerNode: AVAudioPlayerNode = {
        AVAudioPlayerNode()
    }()

    // MARK: -

    init() {
        engine.prepare()
        setupSession()
    }

    // MARK: - Private Methods

    private func setupSession() {
        let session = AVAudioSession.shared
        // MARK: ♻️ REFACTOR LATER ♻️
        try? session.setCategory(.record)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}

extension VoiceRecorder: RecorderType {
    func record(_ fileURL: URL) throws {
        let tapNode: AVAudioMixerNode = mixerNode
        let recordingFormat = tapNode.outputFormat(forBus: 0)

        let audioFile = try AVAudioFile(forWriting: fileURL, settings: recordingFormat.settings)

        tapNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (pcmBuffer, _) in
            try? audioFile.write(from: pcmBuffer)
        }

        try engine.start()
    }

    func pause() {
        engine.pause()
    }

    func resume() throws {
        try engine.start()
    }

    func stop() {

        engine.stop()
        let tapNode: AVAudioMixerNode = mixerNode
        tapNode.removeTap(onBus: 0) // ❗️
    }
}

// class Recorder {
//    enum State {
//        case recording, paused, stopped
//    }
//    
//    var onTimeChange: ((Double) -> ())?
//    
//    private var engine: AVAudioEngine!
//    private var mixerNode: AVAudioMixerNode!
//    private var playerNode: AVAudioPlayerNode!
//    private var state: State = .stopped
//    
//    // MARK: ⚠️ DEVELOP ZONE ⚠️
//    private var fileURL: URL?
//    var assetURL: URL? { fileURL }
//    
//    init() {
//        setupSession()
//        setupEngine()
//    }
//    
//    func startRecording() throws {
//        let tapNode: AVAudioNode = mixerNode
//        let format = tapNode.outputFormat(forBus: 0)
////        if tapNode.engine == nil {
////            engine.attach(mixerNode)
////            
////        }
//        // MARK: ⚠️ DEVELOP ZONE ⚠️
//        
//        fileURL = URL(string: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)?.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
//        guard let fileURL = fileURL else { return }
//        print(fileURL)
//        let outputAudioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
//        
//        
//        tapNode.installTap(onBus: 0, bufferSize: 128, format: format) { (buffer, audioTime) in
//            print(buffer.frameCapacity)
//            try? outputAudioFile.write(from: buffer)
//            let time = Double(audioTime.sampleTime) / audioTime.sampleRate
//            self.onTimeChange?(time)
////            print("🔊 - \(time)")
//        }
//        state = .recording
//        
//        try engine.start()
//    }
//    
//    func resumeRecording() throws {
//        try engine.start()
//        state = .recording
//    }
//    
//    func pauseRecording() {
//        engine.pause()
//        state = .paused
//    }
//    
//    func stopRecording() {
//        engine.stop()
//        mixerNode.removeTap(onBus: 0)
////        engine.detach(mixerNode)
//        state = .stopped
//        try? AVAudioSession.shared.setActive(false, options: .notifyOthersOnDeactivation)
//    }
//    
//    func togglePlay() throws {
//        if (playerNode.isPlaying) {
//            engine.stop()
//            playerNode.stop()
//            
//        } else {
//            mixerNode.volume = 1
//            try schedulePlayerContent()
//            try engine.start()
//            playerNode.play()
//        }
//    }
//    
//    func deleteRecording() throws {
//        guard let fileURL = fileURL,
//              !engine.isRunning else { return }
//        try FileManager.default.removeItem(at: fileURL)
//    }
//    
//    fileprivate func schedulePlayerContent() throws {
//        if let recordingFile = try createPlaybackFile() {
//            playerNode.scheduleFile(recordingFile, at: nil)
//        }
//    }
//    
//    fileprivate func createPlaybackFile() throws -> AVAudioFile? {
//        guard let fileURL = fileURL else { return nil }
//        return try AVAudioFile(forReading: fileURL)
//    }
//    
//    fileprivate func setupSession() {
//        let session = AVAudioSession.shared
//        try? session.setCategory(.record)
//        try? session.setActive(true, options: .notifyOthersOnDeactivation)
//    }
//    
//    fileprivate func setupEngine() {
//        engine = AVAudioEngine()
//        mixerNode = AVAudioMixerNode()
//        playerNode = AVAudioPlayerNode()
//        
//        engine.attach(mixerNode)
//        engine.attach(playerNode)
//        
//        makeConnections()
//        
//        engine.prepare()
//    }
//    
//    fileprivate func makeConnections() {
//        let inputNode = engine.inputNode
//        let inputFormat = inputNode.outputFormat(forBus: 0)
//        engine.connect(inputNode, to: mixerNode, format: inputFormat)
//        
//        let mainMixerNode = engine.mainMixerNode
//        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
//        engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
//        
//        engine.connect(playerNode, to: mixerNode, format: mixerFormat)
//    }
// }
//
