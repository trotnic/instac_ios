//
//  Recorder.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      31.03.21
//

import AVFoundation

class Recorder {
    enum State {
        case recording, paused, stopped
    }
    
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var playerNode: AVAudioPlayerNode!
    private var state: State = .stopped
    
    // MARK: ⚠️ DEVELOP ZONE ⚠️
    private var fileURL: URL?
    var assetURL: URL? { fileURL }
    
    init() {
        setupSession()
        setupEngine()
    }
    
    func startRecording() throws {
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)

        // MARK: ⚠️ DEVELOP ZONE ⚠️
        
        fileURL = URL(string: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)?.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        guard let fileURL = fileURL else { return }
        print(fileURL)
        let outputAudioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
        
        try engine.start()
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) { (buffer, time) in
            try? outputAudioFile.write(from: buffer)
            
            print("🔊 - \(time)")
        }

        state = .recording
    }
    
    func resumeRecording() throws {
        try engine.start()
        state = .recording
    }
    
    func pauseRecording() {
        engine.pause()
        state = .paused
    }
    
    func stopRecording() {
        mixerNode.removeTap(onBus: 0)
        
        engine.stop()
        state = .stopped
    }
    
    func togglePlay() throws {
        if (playerNode.isPlaying) {
            engine.stop()
            playerNode.stop()
            
        } else {
            mixerNode.volume = 1
            try schedulePlayerContent()
            try engine.start()
            playerNode.play()
        }
    }
    
    fileprivate func schedulePlayerContent() throws {
        if let recordingFile = try createPlaybackFile() {
            playerNode.scheduleFile(recordingFile, at: nil)
        }
    }
    
    fileprivate func createPlaybackFile() throws -> AVAudioFile? {
        guard let fileURL = fileURL else { return nil }
        return try AVAudioFile(forReading: fileURL)
    }
    
    fileprivate func setupSession() {
        let session = AVAudioSession.shared
        try? session.setCategory(.record)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    fileprivate func setupEngine() {
        engine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        playerNode = AVAudioPlayerNode()
        
        mixerNode.volume = 0
//        mixerNode.volume = 0
        engine.attach(mixerNode)
        engine.attach(playerNode)
        
        makeConnections()
        
        engine.prepare()
    }
    
    fileprivate func makeConnections() {
        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        engine.connect(inputNode, to: mixerNode, format: inputFormat)
        
        let mainMixerNode = engine.mainMixerNode
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
        
        engine.connect(playerNode, to: mixerNode, format: mixerFormat)
    }
}

