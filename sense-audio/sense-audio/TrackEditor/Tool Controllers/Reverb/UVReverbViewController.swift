//
//  UVReverbViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UVReverbViewController: UIViewController, UVTrackToolController {

    private struct Constants {
        static let reuseIdentifier = "cell"
        static let singlePresetTableTag = 1
        static let allPresetsTableTag = 2
    }

    @IBOutlet private weak var wetDryCurrentValueLabel: UILabel!
    @IBOutlet private weak var wetDrySlider: UISlider!
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var saveButton: UIButton!

    @IBOutlet private weak var mainView: UIView!

    @IBOutlet private weak var presetTableView: UITableView!
    @IBOutlet private weak var allPresetsTableView: UITableView!

    @IBOutlet private var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var allPresetsTableViewLeadingConstraint: NSLayoutConstraint!

    private let preset: MutableProperty<UVReverbPresset> = MutableProperty(.mediumHall)
    private var reverb: UVReverb!

    var saveSignal: Signal<Void, Never> { _saveSignal }
    private let (_saveSignal, _saveObserver) = Signal<Void, Never>.pipe()

}

// MARK: - Public interface

extension UVReverbViewController {
    static func instantiate(_ reverb: UVReverb?) -> UVReverbViewController {
        let controller = UVReverbViewController(nibName: "UVReverbViewController", bundle: nil)
        controller.reverb = reverb
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVReverbViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        bindReverb()
        setupTableViews()
    }
}

// MARK: - Private interface

private extension UVReverbViewController {
    func bindViews() {
        wetDryCurrentValueLabel.reactive.text <~ wetDrySlider.reactive.values.map({ "\($0)%" })

        saveButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self._saveObserver.send(value: ())
            }
    }

    func bindReverb() {
        switcher.reactive.isOn <~ reverb.isOn
        reverb.isOn <~ switcher.reactive.isOnValues

        preset.value = reverb.preset.value.representation
        reverb.preset <~ preset.map({ $0.representation })

        wetDrySlider.reactive.value <~ reverb.wetDryMix
        reverb.wetDryMix <~ wetDrySlider.reactive.values
    }

    func setupTableViews() {
        presetTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        allPresetsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        presetTableView.tag = Constants.singlePresetTableTag
        allPresetsTableView.tag = Constants.allPresetsTableTag
    }

}

// MARK: - UITableViewDataSource

extension UVReverbViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Constants.singlePresetTableTag {
            return 1
        } else {
            return UVReverbPresset.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)

        if tableView.tag == Constants.singlePresetTableTag {
            cell.textLabel?.reactive.text <~ preset.map({ $0.rawValue })
            cell.accessoryType = .disclosureIndicator
        } else {
            let pointCase = UVReverbPresset.allCases[indexPath.row]
            cell.textLabel?.text = pointCase.rawValue
            cell.accessoryType = pointCase == preset.value ? .checkmark : .none
        }

        return cell
    }

}

// MARK: - UITableViewDelegate

extension UVReverbViewController: UITableViewDelegate {
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

            preset.value = UVReverbPresset.allCases[indexPath.row]
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
