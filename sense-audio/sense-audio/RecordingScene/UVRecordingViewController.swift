//
//  UVRecordingViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      29.03.21
//

import UIKit

import AVFoundation

// MARK: ⚠️ DEVELOP ZONE ⚠️

fileprivate enum State {
    case recording, playing, paused
}


class UVRecordingViewController: UIViewController {
    
    // MARK: ⚠️ DEVELOP ZONE ⚠️
    
    private var state: State = .paused
    
    // MARK: - Lazy Properties
    
    lazy var recordingDurationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playingDurationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playButton: UIButton = {
        let view = UVButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "play"), for: .normal)
        view.addTarget(self, action: #selector(playBackAction(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var recordButton: UIButton = {
        let view = UVButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "record.circle"), for: .normal)
        view.addTarget(self, action: #selector(recordAction(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveAssetAction))
        item.isEnabled = false
        return item
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "00:00"
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var recorder: Recorder = .init()
//    private var recorder: AVAudioRecorder?
    
    
    private lazy var fileManager: FileManager = {
        let manager = FileManager.default
        //
        return manager
    }()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    // MARK: - Private Layout
    
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = doneButton
        layoutRecordButton()
        layoutPlayButton()
        layoutTimeLabel()
    }
    
    private func layoutPlayButton() {
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func layoutRecordButton() {
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            recordButton.heightAnchor.constraint(equalToConstant: 60),
            recordButton.widthAnchor.constraint(equalToConstant: 60),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func layoutTimeLabel() {
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Private Logic
    
    @objc private func recordAction(_ sender: UIButton) {
        switch state {
        case .paused:
            UIView.transition(with: recordButton, duration: 0.2, options: [.transitionCrossDissolve]) {
                self.recordButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            }
            UIView.transition(with: playButton, duration: 0.2, options: [.transitionCrossDissolve]) {
                self.playButton.isEnabled = false
            }
            state = .recording
            // MARK: ⚠️ DEVELOP ZONE ⚠️
            try? recorder.startRecording()
        case .playing:
            break
        case .recording:
            UIView.transition(with: recordButton, duration: 0.2, options: [.transitionCrossDissolve]) {
                self.recordButton.isEnabled = false
            }
            UIView.transition(with: playButton, duration: 0.2, options: [.transitionCrossDissolve]) {
                self.playButton.isEnabled = true
            }
            UIView.animate(withDuration: 0.2) {
                self.doneButton.isEnabled = true
            }

//            UIView.transition(with: doneButton., duration: 0.2, options: [.transitionCrossDissolve]) {
                
//            }

            state = .paused
            recorder.stopRecording()
        }
//        switch recodingState {
//        case .paused:
//            try? recorder.startRecording()
//            recodingState = .recording
//            break
//        case .recording:
//            recorder.stopRecording()
//            recodingState = .paused
//        }
    }
    
    @objc private func playBackAction(_ sender: UIButton) {
//        try? recorder.togglePlay()
//        switch playbackState {
//        case .paused:
//            
//            playbackState = .playing
//            break
//        case .playing:
//            try? reco
//        }
    }
    
    @objc private func saveAssetAction() {
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let fileURL = recorder.assetURL {
            let newFileURL = directoryURL.appendingPathComponent(fileURL.lastPathComponent)
//            print(directoryURL)
//            FileManager.default.copy
            print(fileURL)
            try? FileManager.default.copyItem(at: fileURL, to: newFileURL)
            try? FileManager.default.removeItem(at: fileURL)
            print(newFileURL)
//           let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) {
//            self.contents.append(contentsOf: contents.compactMap({ URL(string: $0) }))
        }
    }
}
