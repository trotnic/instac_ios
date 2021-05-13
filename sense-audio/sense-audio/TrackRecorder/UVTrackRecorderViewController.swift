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
import FDWaveformView

class UVTrackRecorderViewController: UIViewController {

    // MARK: ⚠️ DEVELOP ZONE ⚠️

    private enum RecorderState {
        case recording, stopped
    }

    private enum PlayerState {
        case playing, stopped
    }

    private struct Constants {
        static let fadeDuration: TimeInterval = 0.2
    }

    // MARK: - Properties
    
    @IBOutlet weak var waveformView: FDWaveformView!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var recorderState: RecorderState = .stopped
    private var playerState: PlayerState = .stopped

    private var recorderViewModel: UVRecorderViewModelType!
    private var playerViewModel: UVPlayerViewModelType!

    // MARK: - Initialization

}

// MARK: - Public interface

extension UVTrackRecorderViewController {
    static func instantiate(recorderViewModel: UVRecorderViewModelType, playerViewModel: UVPlayerViewModelType) -> UVTrackRecorderViewController {
        let controller = UVTrackRecorderViewController(nibName: String(describing: self), bundle: nil)
        controller.recorderViewModel = recorderViewModel
        controller.playerViewModel = playerViewModel
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVTrackRecorderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        bindViews()
        setupAppearance()
        
        
    }
}

// MARK: - Private interface

private extension UVTrackRecorderViewController {
    func bindToViewModel() {
        recorderViewModel.time
            .signal
            .observeValues { time in
                self.timeLabel.text = time
            }
        
        recorderViewModel.audioFileURL
            .skipNil()
            .observe(on: QueueScheduler.main)
            .observeValues { [self] fileURL in
                animateTransition(of: waveformView) {
                    waveformView.audioURL = fileURL
                }
            }
        
        recorderViewModel.playbackEnd
            .observeValues {
                self.stopPlaying(auto: true)
            }
    }
    
    func bindViews() {
        playButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [self] _ in
                switch playerState {
                case .playing:
                    stopPlaying(auto: false)
                case .stopped:
                    startPlaying()
                }
            }
        
        recordButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [self] _ in
                switch recorderState {
                case .stopped:
                    startRecording()
                case .recording:
                    stopRecording()
                }
            }
        
        deleteButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.deleteRecording()
            }
        
        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.saveRecording()
            }
    }
    
    // MARK: - UI
    
    func setupAppearance() {
        view.backgroundColor = .systemBackground
        
        playButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.imageView?.contentMode = .scaleAspectFit
        recordButton.imageView?.contentMode = .scaleAspectFit
        saveButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func animateTransition(of view: UIView, callback: @escaping () -> Void) {
        UIView.transition(with: view, duration: Constants.fadeDuration, options: [.transitionCrossDissolve]) {
            callback()
        }
    }
    
    // MARK: - Playback & Recording events
    
    func startPlaying() {
        recorderViewModel.playRecord()
        playerState = .playing
        
        animateTransition(of: playButton) {
            self.playButton.setImage(UIImage(.pause), for: .normal)
        }
        
        animateTransition(of: saveButton) {
            self.saveButton.isEnabled = false
        }
        
        animateTransition(of: deleteButton) {
            self.deleteButton.isEnabled = false
        }
    }
    
    func stopPlaying(auto: Bool) {
        if !auto {
            recorderViewModel.playRecord()
        }
        
        playerState = .stopped
        
        animateTransition(of: playButton) {
            self.playButton.setImage(UIImage(.play), for: .normal)
        }
        
        animateTransition(of: saveButton) {
            self.saveButton.isEnabled = true
        }
        
        animateTransition(of: deleteButton) {
            self.deleteButton.isEnabled = true
        }
    }
    
    func startRecording() {
        recorderViewModel.startRecording()
        recorderState = .recording
        
        animateTransition(of: recordButton) {
            self.recordButton.setImage(UIImage(.stop), for: .normal)
        }
        animateTransition(of: deleteButton) {
            self.deleteButton.isEnabled = false
        }
        animateTransition(of: saveButton) {
            self.saveButton.isEnabled = false
        }
    }
    
    func stopRecording() {
        recorderViewModel.stopRecording()
        recorderState = .stopped
        
        animateTransition(of: recordButton) { [self] in
            recordButton.setImage(UIImage(.record), for: .normal)
            recordButton.isEnabled = false
        }
        
        animateTransition(of: deleteButton) {
            self.deleteButton.isEnabled = true
        }
        
        animateTransition(of: saveButton) {
            self.saveButton.isEnabled = true
        }
        
        animateTransition(of: playButton) {
            self.playButton.isEnabled = true
        }
    }
    
    func deleteRecording() {
        recorderViewModel.deleteRecord()
        
        animateTransition(of: deleteButton) {
            self.deleteButton.isEnabled = false
        }
        
        animateTransition(of: saveButton) {
            self.saveButton.isEnabled = false
        }
        
        animateTransition(of: playButton) {
            self.playButton.isEnabled = false
        }
        
        animateTransition(of: recordButton) {
            self.recordButton.isEnabled = true
        }
    }
    
    func saveRecording() {
        recorderViewModel.saveRecord()
    }
}
