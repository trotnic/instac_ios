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
        static let fadeDuration: TimeInterval = 0.2
        static let playIM = "play"
        static let recordStartIM = "record.circle"
    }

    // MARK: - Properties

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var mainStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var equalizerToolButton: UIButton!
    @IBOutlet weak var distortionToolButton: UIButton!
    @IBOutlet weak var delayToolButton: UIButton!
    @IBOutlet weak var reverbToolButton: UIButton!

    @IBOutlet weak var toolboxMainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolboxHorizontalStackView: UIStackView!

    private weak var lastToolboxController: UIViewController?
    private var lastToolboxLeadingConstraint: NSLayoutConstraint?
    private var lastToolboxTrailingConstraint: NSLayoutConstraint?
    private var lastToolboxTopConstraint: NSLayoutConstraint?
    private var lastToolboxBottomConstraint: NSLayoutConstraint?
    private var lastToolboxHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var toolboxContainerView: UIView!
    @IBOutlet weak var toolboxHiddenHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolboxPresentedHeightConstraint: NSLayoutConstraint!

    @IBOutlet var pageViewController: UIPageViewController!
    
    var toolboxConstraints: [NSLayoutConstraint] {
        [lastToolboxLeadingConstraint, lastToolboxTopConstraint, lastToolboxTrailingConstraint, lastToolboxBottomConstraint, lastToolboxHeightConstraint].compactMap({  $0 })
    }

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
        setupAppearance()
        bindToolButtons()

        toolboxMainViewHeightConstraint.constant = 0
    }
}

// MARK: - Private interface

private extension UVTrackEditorViewController {
    func bindToolButtons() {
        equalizerToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .equalizer)
//                self.pushChild(UVEqualizerViewController.instantiate())
            }

        distortionToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .distortion)
//                self.pushChild(UVDistortionViewController.instantiate())
            }

        delayToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .delay)
//                self.pushChild(UVDelayViewController.instantiate())
            }

        reverbToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.keep(tool: .reverb)
//                self.pushChild(UVReverbViewController.instantiate())
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
            }
        }
        
        currentTool = tool
        
        switch tool {
        case .equalizer:
            pageViewController.setViewControllers([UVEqualizerViewController.instantiate()], direction: .forward, animated: false)
            break
        case .distortion:
            pageViewController.setViewControllers([UVDistortionViewController.instantiate()], direction: .forward, animated: false)
            break
        case .delay:
            pageViewController.setViewControllers([UVDelayViewController.instantiate()], direction: .forward, animated: false)
            break
        case .reverb:
            pageViewController.setViewControllers([UVReverbViewController.instantiate()], direction: .forward, animated: false)
            break
        case .none:
            toolboxHiddenHeightConstraint.isActive = true
            toolboxPresentedHeightConstraint.isActive = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
