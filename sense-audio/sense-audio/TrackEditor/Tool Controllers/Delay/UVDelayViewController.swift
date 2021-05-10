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

class UVDelayViewController: UIViewController {

    @IBOutlet weak var delayTimeCurrentValueLabel: UILabel!
    @IBOutlet weak var feedbackCurrentValueLabel: UILabel!
    @IBOutlet weak var cutoffCurrentVallueLabel: UILabel!
    @IBOutlet weak var wetDryCurrentValueLabel: UILabel!

    @IBOutlet weak var delayTimeSlider: UISlider!
    @IBOutlet weak var feedbackSlider: UISlider!
    @IBOutlet weak var cufoffSlider: UISlider!
    @IBOutlet weak var wetDrySlider: UISlider!

    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var saveButton: UIButton!

}

// MARK: - Public interface

extension UVDelayViewController {
    static func instantiate() -> UVDelayViewController {
        UVDelayViewController(nibName: "UVDelayViewController", bundle: nil)
    }
}

// MARK: - UIViewController overrides

extension UVDelayViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }
}

// MARK: - Private interface

private extension UVDelayViewController {
    func bindViews() {
        delayTimeCurrentValueLabel.reactive.text <~ delayTimeSlider.reactive.values.map({ "\($0)s" })
        feedbackCurrentValueLabel.reactive.text <~ feedbackSlider.reactive.values.map({ "\($0)%" })
        cutoffCurrentVallueLabel.reactive.text <~ cufoffSlider.reactive.values.map({ "\($0) Hz" })
        wetDryCurrentValueLabel.reactive.text <~ wetDrySlider.reactive.values.map({ "\($0)%" })
    }
}
