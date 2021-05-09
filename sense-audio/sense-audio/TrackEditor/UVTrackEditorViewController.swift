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
    @IBOutlet weak var mainStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var equalizerToolButton: UIButton!

//    private let playButton: UIButton = {
//        let view = UVButton()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setImage(UIImage(systemName: Constants.playIM), for: .normal)
//        view.addTarget(self, action: #selector(playBackAction(_:)), for: .touchUpInside)
//        return view
//    }()

    private var editorViewModel: UVTrackEditorViewModelType?
    private var state: State = .paused

    func attach(editor: UVTrackEditorViewModelType) {
        editorViewModel = editor
    }
}

// MARK: - UIViewController overrides

extension UVTrackEditorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        equalizerToolButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.pushChild()
            }
    }
}

// MARK: - Private interface

private extension UVTrackEditorViewController {
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
    func pushChild() {
        let childViewController = UVDistortionViewController(nibName: "UVDistortionViewController", bundle: nil)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(childViewController)

        mainStackBottomConstraint.isActive = false
        view.addSubview(childViewController.view)
        childViewController.view.alpha = 0

        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            childViewController.view.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            childViewController.view.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 2.4)
        ])

        UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) { [self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                childViewController.view.alpha = 1
            }
        } completion: { _ in
            childViewController.didMove(toParent: self)
        }

    }
}
