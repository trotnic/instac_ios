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

/**
 This one is responsible
 for presentint editor interface
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
        static let playIM = "play"
        static let recordStartIM = "record.circle"
    }

    // MARK: - Properties
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var equalizerToolButton: UIButton!
    @IBOutlet weak var distortionToolButton: UIButton!
    @IBOutlet weak var delayToolButton: UIButton!
    @IBOutlet weak var reverbToolButton: UIButton!
    
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

//    private let playButton: UIButton = {
//        let view = UVButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setImage(UIImage(systemName: Constants.playIM), for: .normal)
//        view.addTarget(self, action: #selector(playBackAction(_:)), for: .touchUpInside)
//        return view
//    }()

    private var editorViewModel: UVTrackEditorViewModelType?
    private var playerState: State = .paused
    private var toolboxState: ToolboxState = .hidden
    private var currentTool: Tool = .none

    func attach(editor: UVTrackEditorViewModelType) {
        editorViewModel = editor
    }
}

// MARK: - UIViewController overrides

extension UVTrackEditorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        setupAppearance()
        bindToolButtons()
    }
}

// MARK: - Private interface

private extension UVTrackEditorViewController {
    func bindViews() {
        playButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [self] _ in
                switch playerState {
                case .playing:
                    editorViewModel?.pause().start()
                    playerState = .paused
                case .paused:
                    editorViewModel?.play().start()
                    playerState = .playing
                }
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

        delayToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .delay)
            }

        reverbToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .reverb)
            }
    }

    @objc func playBackAction(_ sender: UIButton) {
//        switch state {
//        case .paused:
//            editorViewModel?
//                .play()
//                .on(value: { [self] in
//                    animateTransition(of: playButton) {
//                        playButton.setImage(UIImage(systemName: "pause"), for: .normal)
//                    }
//                    state = .playing
//                })
//                .start()
//        case .playing:
//            editorViewModel?
//                .pause()
//                .on(value: { [self] in
//                    animateTransition(of: playButton) {
//                        playButton.setImage(UIImage(systemName: "play"), for: .normal)
//                    }
//                    state = .paused
//                })
//                .start()
//        }
    }

}

private extension UVTrackEditorViewController {
    func setupAppearance() {
//        view.backgroundColor = .systemBackground
//
//        view.addSubview(playButton)
//
//        NSLayoutConstraint.activate([
//            playButton.heightAnchor.constraint(equalToConstant: 60),
//            playButton.widthAnchor.constraint(equalToConstant: 60),
//            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
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
