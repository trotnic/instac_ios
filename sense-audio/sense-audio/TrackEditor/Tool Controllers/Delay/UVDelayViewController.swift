//
//  UVDelayViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class UVDelayViewController: UIViewController, UVTrackToolController {

    @IBOutlet weak var delayTimeCurrentValueLabel: UILabel!
    @IBOutlet weak var feedbackCurrentValueLabel: UILabel!
    @IBOutlet weak var cutoffCurrentVallueLabel: UILabel!
    @IBOutlet weak var wetDryCurrentValueLabel: UILabel!

    @IBOutlet weak var delayTimeSlider: UISlider!
    @IBOutlet weak var feedbackSlider: UISlider!
    @IBOutlet weak var cutoffSlider: UISlider!
    @IBOutlet weak var wetDrySlider: UISlider!

    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    private var delay: UVDelay!
    
    var saveSignal: Signal<Void, Never> { _saveSignal }
    private let (_saveSignal, _saveObserver) = Signal<Void, Never>.pipe()

}

// MARK: - Public interface

extension UVDelayViewController {
    static func instantiate(_ delay: UVDelay?) -> UVDelayViewController {
        let controller = UVDelayViewController(nibName: "UVDelayViewController", bundle: nil)
        controller.delay = delay
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVDelayViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        bindDelay()
    }
}

// MARK: - Private interface

private extension UVDelayViewController {
    func bindViews() {
        delayTimeCurrentValueLabel.reactive.text <~ delayTimeSlider.reactive.values.map({ "\($0)s" })
        feedbackCurrentValueLabel.reactive.text <~ feedbackSlider.reactive.values.map({ "\($0)%" })
        cutoffCurrentVallueLabel.reactive.text <~ cutoffSlider.reactive.values.map({ "\($0) Hz" })
        wetDryCurrentValueLabel.reactive.text <~ wetDrySlider.reactive.values.map({ "\($0)%" })
        
        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self._saveObserver.send(value: ())
            }
    }
    
    func bindDelay() {
        switcher.reactive.isOn <~ delay.isOn
        delay.isOn <~ switcher.reactive.isOnValues
        
        delayTimeSlider.reactive.value <~ delay.delayTime
        delay.delayTime <~ delayTimeSlider.reactive.values
        
        feedbackSlider.reactive.value <~ delay.feedback
        delay.feedback <~ feedbackSlider.reactive.values
        
        cutoffSlider.reactive.value <~ delay.lowPassCutoff
        delay.lowPassCutoff <~ cutoffSlider.reactive.values
        
        wetDrySlider.reactive.value <~ delay.wetDryMix
        delay.wetDryMix <~ wetDrySlider.reactive.values
    }
}
