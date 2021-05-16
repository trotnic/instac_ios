//
//  UVEqualizerViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UVEqualizerViewController: UIViewController, UVTrackToolController {

    @IBOutlet private weak var gainSlider: UISlider!
    @IBOutlet private weak var currentValueLabel: UILabel!
    @IBOutlet private weak var minValueLabel: UILabel!
    @IBOutlet private weak var maxValueLabel: UILabel!

    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var switcher: UISwitch!

    private var equalizer: UVEqualizer!

    var saveSignal: Signal<Void, Never> { _saveSignal }
    private let (_saveSignal, _saveObserver) = Signal<Void, Never>.pipe()
}

// MARK: - Public interface

extension UVEqualizerViewController {
    static func instantiate(_ equalizer: UVEqualizer?) -> UVEqualizerViewController {
        let controller = UVEqualizerViewController(nibName: "UVEqualizerViewController", bundle: nil)
        controller.equalizer = equalizer
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVEqualizerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        bindEqualizer()
    }
}

// MARK: - Private interface

private extension UVEqualizerViewController {
    func bindViews() {
        currentValueLabel.reactive.text <~ gainSlider.reactive.values.map({ "\($0) db" })

        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self._saveObserver.send(value: ())
            }
    }

    func bindEqualizer() {
        switcher.reactive.isOn <~ equalizer.isOn
        equalizer.isOn <~ switcher.reactive.isOnValues

        gainSlider.reactive.value <~ equalizer.globalGain
        equalizer.globalGain <~ gainSlider.reactive.values
    }
}
