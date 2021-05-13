//
//  UVTrackEditorViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      02.05.2021
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import FDWaveformView

/**
 This one is responsible
 for presenting editor interface
 */

protocol UVTrackToolController {
    var saveSignal: Signal<Void, Never> { get }
}

class UVTrackEditorViewController: UIViewController {

    // MARK: ⚠️ DEVELOP ZONE ⚠️

    private enum Tool {
        case equalizer, distortion, delay, reverb, none
    }

    private enum ToolboxState {
        case presented, hidden
    }

    private enum State {
        case playing, paused
    }

    private struct Constants {
        static let fadeDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    @IBOutlet weak var waveformView: FDWaveformView!
    @IBOutlet weak var playbackTimeLabel: UILabel!

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var equalizerToolButton: UIButton!
    @IBOutlet weak var distortionToolButton: UIButton!
//    @IBOutlet weak var delayToolButton: UIButton!
    @IBOutlet weak var reverbToolButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var toolboxMainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolboxHorizontalStackView: UIStackView!

    @IBOutlet weak var toolboxHiddenHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolboxPresentedHeightConstraint: NSLayoutConstraint!

    @IBOutlet var pageViewController: UIPageViewController!

    private lazy var equalizerController: UVEqualizerViewController = {
        let controller = UVEqualizerViewController.instantiate(editorViewModel?.toolbox.equalizer)

        controller.saveSignal
            .observeValues { _ in
                self.keep(tool: .none)
            }
        return controller
    }()

    private lazy var distortionController: UVDistortionViewController = {
        let controller = UVDistortionViewController.instantiate(editorViewModel?.toolbox.distortion)

        controller.saveSignal
            .observeValues { _ in
                self.keep(tool: .none)
            }
        return controller
    }()

    private lazy var delayController: UVDelayViewController = {
        let controller = UVDelayViewController.instantiate(editorViewModel?.toolbox.delay)

        controller.saveSignal
            .observeValues { _ in
                self.keep(tool: .none)
            }
        return controller
    }()

    private lazy var reverbController: UVReverbViewController = {
        let controller = UVReverbViewController.instantiate(editorViewModel?.toolbox.reverb)

        controller.saveSignal
            .observeValues { _ in
                self.keep(tool: .none)
            }
        return controller
    }()

    private var editorViewModel: UVTrackEditorViewModelType?
    private var playerState: State = .paused
    private var toolboxState: ToolboxState = .hidden
    private var currentTool: Tool = .none
}

// MARK: - Public interface

extension UVTrackEditorViewController {
    static func instantiate(_ viewModel: UVTrackEditorViewModelType) -> UVTrackEditorViewController {
        let controller = UVTrackEditorViewController(nibName: String(describing: self), bundle: nil)
        controller.editorViewModel = viewModel
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVTrackEditorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        bindToolButtons()
        bindViews()
        setupAppearance()
    }
}

// MARK: - Private interface

private extension UVTrackEditorViewController {
    func bindToViewModel() {
        editorViewModel?.audioFileURL
            .observe(on: QueueScheduler.main)
            .on(value: {
                self.waveformView.audioURL = $0
            })
            .start()

        editorViewModel?.playbackEnd
            .observe(on: QueueScheduler.main)
            .observeValues({
                self.stopPlayback()
            })
        
        editorViewModel?.savingStart
            .observe(on: QueueScheduler.main)
            .observeValues({ [self] in
                playButton.isEnabled = false
                cancelButton.isEnabled = false
                equalizerToolButton.isEnabled = false
                distortionToolButton.isEnabled = false
                reverbToolButton.isEnabled = false
            })
    }

    func bindViews() {
        playButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [self] _ in
                switch playerState {
                case .playing:
                    editorViewModel?.pause().start()
                    stopPlayback()
                case .paused:
                    editorViewModel?.play().start()
                    startPlayback()
                }
            }

        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.editorViewModel?.save()
            }
    }

    func bindToolButtons() {
        equalizerToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .equalizer)
            }

        distortionToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .distortion)
            }

//        delayToolButton.reactive
//            .controlEvents(.touchUpInside)
//            .observeValues { _ in
//                self.keep(tool: .delay)
//            }

        reverbToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .reverb)
            }
    }
    
    func startPlayback() {
        animateTransition(of: playButton) {
            self.playButton.setImage(UIImage(.pause, point: .largeButton), for: .normal)
        }
        playerState = .playing
    }
    
    func stopPlayback() {
        animateTransition(of: playButton) {
            self.playButton.setImage(UIImage(.play, point: .largeButton), for: .normal)
        }
        playerState = .paused
    }

}

private extension UVTrackEditorViewController {
    func setupAppearance() {
        animateTransition(of: playButton) {
            self.playButton.setImage(UIImage(.play, point: .largeButton), for: .normal)
        }
    }
}

private extension UVTrackEditorViewController {
    func animateTransition(of view: UIView, callback: @escaping () -> Void) {
        UIView.transition(with: view, duration: Constants.fadeDuration, options: [.transitionCrossDissolve]) {
            callback()
        }
    }
}

private extension UVTrackEditorViewController {
    private func keep(tool: Tool) {
        if currentTool == .none {
            toolboxHiddenHeightConstraint.isActive = false
            toolboxPresentedHeightConstraint.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.pageViewController.view.alpha = 1
            }
        }

        guard currentTool != tool else {
            return
        }

        currentTool = tool

        switch tool {
        case .equalizer:
            pageViewController.setViewControllers([equalizerController], direction: .forward, animated: false)
        case .distortion:
            pageViewController.setViewControllers([distortionController], direction: .forward, animated: false)
        case .delay:
            pageViewController.setViewControllers([delayController], direction: .forward, animated: false)
        case .reverb:
            pageViewController.setViewControllers([reverbController], direction: .forward, animated: false)
        case .none:
            toolboxHiddenHeightConstraint.isActive = true
            toolboxPresentedHeightConstraint.isActive = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.pageViewController.view.alpha = 0
            }
        }
    }
}
