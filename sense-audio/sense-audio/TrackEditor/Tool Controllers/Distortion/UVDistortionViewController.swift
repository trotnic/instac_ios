//
//  UVDistortionViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UVDistortionViewController: UIViewController, UVTrackToolController {

    private struct Constants {
        static let reuseIdentifier = "cell"
        static let singlePresetTableTag = 1
        static let allPresetsTableTag = 2
    }

    @IBOutlet private weak var preGainSlider: UISlider!
    @IBOutlet private weak var preGainCurrentValueLabel: UILabel!
    @IBOutlet private weak var wetDryMixSlider: UISlider!
    @IBOutlet private weak var wetDryMixCurrentValueLabel: UILabel!

    @IBOutlet private weak var presetTableView: UITableView!
    @IBOutlet private weak var allPresetsTableView: UITableView!

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var allPresetsTableViewLeadingConstraint: NSLayoutConstraint!

    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var saveButton: UIButton!

    private let preset: MutableProperty<UVDistortionPreset> = MutableProperty(.drumsLoFi)
    private var distortion: UVDistortion!

    var saveSignal: Signal<Void, Never> { _saveSignal }
    private let (_saveSignal, _saveObserver) = Signal<Void, Never>.pipe()

}

// MARK: - Public interface

extension UVDistortionViewController {
    static func instantiate(_ distortion: UVDistortion?) -> UVDistortionViewController {
        let controller = UVDistortionViewController(nibName: "UVDistortionViewController", bundle: nil)
        controller.distortion = distortion
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVDistortionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        bindDistortion()
        setupTableViews()
    }
}

// MARK: - Private interface

private extension UVDistortionViewController {
    func bindViews() {
        preGainCurrentValueLabel.reactive.text <~ preGainSlider.reactive.values.map({ "\($0)db" })
        wetDryMixCurrentValueLabel.reactive.text <~ wetDryMixSlider.reactive.values.map({ "\($0)%" })

        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self._saveObserver.send(value: ())
            }
    }

    func bindDistortion() {
        switcher.reactive.isOn <~ distortion.isOn
        distortion.isOn <~ switcher.reactive.isOnValues

        preGainSlider.reactive.value <~ distortion.preGain
        distortion.preGain <~ preGainSlider.reactive.values

        wetDryMixSlider.reactive.value <~ distortion.wetDryMix
        distortion.wetDryMix <~ wetDryMixSlider.reactive.values

        preset.value = distortion.preset.value.representation
        distortion.preset <~ preset.map({ $0.representation })
    }

    func setupTableViews() {
        presetTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        allPresetsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        presetTableView.tag = Constants.singlePresetTableTag
        allPresetsTableView.tag = Constants.allPresetsTableTag
    }
}

// MARK: - UITableViewDatasource

extension UVDistortionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Constants.singlePresetTableTag {
            return 1
        } else {
            return UVDistortionPreset.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)

        if tableView.tag == Constants.singlePresetTableTag {
            cell.textLabel?.reactive.text <~ preset.map({ $0.rawValue })
            cell.accessoryType = .disclosureIndicator
        } else {
            let pointCase = UVDistortionPreset.allCases[indexPath.row]
            cell.textLabel?.text = pointCase.rawValue
            cell.accessoryType = pointCase == preset.value ? .checkmark : .none
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension UVDistortionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if tableView.tag == Constants.singlePresetTableTag {

            allPresetsTableViewLeadingConstraint.isActive = true
            mainViewTrailingConstraint.isActive = false
            UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: []) { [self] in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                    mainView.alpha = 0
                    allPresetsTableView.alpha = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    view.layoutIfNeeded()
                }
            }
        } else {
            allPresetsTableViewLeadingConstraint.isActive = false
            mainViewTrailingConstraint.isActive = true
            preset.value = UVDistortionPreset.allCases[indexPath.row]
            UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: []) { [self] in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                    mainView.alpha = 1
                    allPresetsTableView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    view.layoutIfNeeded()
                }
            } completion: { _ in
                tableView.reloadData()
            }
        }
    }
}
