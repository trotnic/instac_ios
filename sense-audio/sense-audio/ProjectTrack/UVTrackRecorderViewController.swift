//
//  UVProjectTrackViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      15.04.21
//

import UIKit
import AVFoundation
import ReactiveCocoa
import ReactiveSwift

class UVTrackRecorderViewController: UIViewController {
    
    // MARK: ⚠️ DEVELOP ZONE ⚠️
    
    private enum RecorderState {
        case idle, recording, stopped
    }
    
    private enum PlayerState {
        case idle, playing, paused
    }
    
    private struct Constants {
        static let fadeDuration: TimeInterval = 0.2
        static let playIM = "play"
        static let recordStartIM = "record.circle"
    }
    
    // MARK: - Props
    
    private var recorderState: RecorderState = .idle
    private var playerState: PlayerState = .idle
    
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
        view.setImage(UIImage(systemName: Constants.playIM), for: .normal)
        view.addTarget(self, action: #selector(playBackAction(_:)), for: .touchUpInside)
        view.isEnabled = false
        return view
    }()
    
    lazy var recordButton: UIButton = {
        let view = UVButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: Constants.recordStartIM), for: .normal)
        view.addTarget(self, action: #selector(recordAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /**
     Saves the actual audio file
     and returns to the list of tracks
     */
    lazy var saveButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveAssetAction))
        item.isEnabled = false
        return item
    }()
    
    /**
     Deletes current audio asset
     and refreshes VC state to `.idle`
     */
    lazy var deleteButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAssetAction))
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
    
    private var recorderViewModel: UVRecorderViewModelType
    private var playerViewModel: UVPlayerViewModelType
    
    // MARK: - Initialization
    
    init(recorder recorderViewModel: UVRecorderViewModelType, player playerViewModel: UVPlayerViewModelType) {
        self.recorderViewModel = recorderViewModel
        self.playerViewModel = playerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    // MARK: - Private Layout
    
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [
            saveButton,
            deleteButton
        ]
        
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
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        switch recorderState {
        case .idle:
            recorderViewModel
                .startRecording()
                .on(value: { [self] _ in
                    animateTransition(recordButton) {
                        recordButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                    }
                    animateTransition(playButton) {
                        playButton.isEnabled = false
                    }
                    recorderState = .recording
                })
                .start()
        case .recording:
            recorderViewModel
                .stopRecording()
                .on(value: { [self] _ in
                    animateTransition(recordButton) {
                        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
                        recordButton.isEnabled = false
                    }
                    animateTransition(playButton) {
                        playButton.isEnabled = true
                    }
                    deleteButton.isEnabled = true
                    saveButton.isEnabled = true
                    recorderState = .stopped
                })
                .start()
        case .stopped:
            break
        }
    }
    
    @objc private func playBackAction(_ sender: UIButton) {
        
        switch playerState {
        case .idle,
             .paused:
            SignalProducer<String?, Never> { [self] (observer, _) in
                observer.send(value: self.recorderViewModel.audioFileName)
            }
            .skipNil()
            .observe(on: UIScheduler())
            .on(value: { [self] fileName in
                playerViewModel
                    .play(track: fileName)
                    .on(event: { (event) in
                        switch event {
                        case .value:
                            animateTransition(playButton) {
                                playButton.setImage(UIImage(systemName: "pause"), for: .normal)
                            }
                            playerState = .playing
                        case .completed:
                            playerViewModel
                                .pause()
                                .on(value: { _ in
                                    animateTransition(playButton) {
                                        playButton.setImage(UIImage(systemName: "play"), for: .normal)
                                    }
                                    playerState = .paused
                                })
                                .start()
                        default:
                            break
                        }
                    })                    
                    .start()
            })
            .start()
            
        case .playing:
            playerViewModel
                .pause()
                .on(value: { [self] _ in
                    animateTransition(playButton) {
                        playButton.setImage(UIImage(systemName: "play"), for: .normal)
                    }
                    playerState = .paused
                })
                .start()
        }
        
    }
    
    @objc private func saveAssetAction() {
        // MARK: ♻️ REFACTOR LATER ♻️
        recorderViewModel.saveRecord()
            .on(value: { [self] _ in
                refreshState()
            })
            .start()
    }
    
    @objc private func deleteAssetAction() {
        recorderViewModel.deleteRecord()
            .on(value: { [self] _ in
                refreshState()
            })
            .start()
    }
    
    private func refreshState() {
        recorderState = .idle
        playerState = .idle
        
        playerViewModel.stop()
        
        animateTransition(recordButton) {
            self.recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            self.recordButton.isEnabled = true
        }
        animateTransition(playButton) {
            self.playButton.isEnabled = false
            self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
        self.deleteButton.isEnabled = false
        self.saveButton.isEnabled = false
    }
}

extension UVTrackRecorderViewController {
    private func animateTransition(_ with: UIView, callback: @escaping () -> Void) {
        UIView.transition(with: with, duration: Constants.fadeDuration, options: [.transitionCrossDissolve]) {
            callback()
        }
    }
}
