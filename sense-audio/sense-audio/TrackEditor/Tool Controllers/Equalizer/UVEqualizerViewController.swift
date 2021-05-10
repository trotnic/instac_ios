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

class UVEqualizerViewController: UIViewController {

    @IBOutlet weak var gainSlider: UISlider!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!

}

// MARK: - Public interface

extension UVEqualizerViewController {
    static func instantiate() -> UVEqualizerViewController {
        UVEqualizerViewController(nibName: "UVEqualizerViewController", bundle: nil)
    }
}

// MARK: - UIViewController overrides

extension UVEqualizerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        bindViews()
    }
}

// MARK: - Private interface

private extension UVEqualizerViewController {
    func bindViews() {
        currentValueLabel.reactive.text <~ gainSlider.reactive.values.map({ "\($0) db" })
    }
}
