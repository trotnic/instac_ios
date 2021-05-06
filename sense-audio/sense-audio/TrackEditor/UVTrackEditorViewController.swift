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

    private let playButton: UIButton = {
        let view = UVButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: Constants.playIM), for: .normal)
        view.addTarget(self, action: #selector(playBackAction(_:)), for: .touchUpInside)
        return view
    }()

    private let editorViewModel: UVTrackEditorViewModelType
    private var state: State = .paused

    init(editor eViewModel: UVTrackEditorViewModelType) {
        editorViewModel = eViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UIViewController overrides

extension UVTrackEditorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}

// MARK: - Private interface

private extension UVTrackEditorViewController {
    @objc func playBackAction(_ sender: UIButton) {
        switch state {
        case .paused:
            editorViewModel
                .play()
                .on(value: { [self] in
                    animateTransition(of: playButton) {
                        playButton.setImage(UIImage(systemName: "pause"), for: .normal)
                    }
                    state = .playing
                })
                .start()
        case .playing:
            editorViewModel
                .pause()
                .on(value: { [self] in
                    animateTransition(of: playButton) {
                        playButton.setImage(UIImage(systemName: "play"), for: .normal)
                    }
                    state = .paused
                })
                .start()
        }
    }

}

private extension UVTrackEditorViewController {
    func setupAppearance() {
        view.backgroundColor = .systemBackground

        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: 60),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension UVTrackEditorViewController {
    func animateTransition(of view: UIView, callback: @escaping () -> Void) {
        UIView.transition(with: view, duration: Constants.fadeDuration, options: [.transitionCrossDissolve]) {
            callback()
        }
    }
}
