//
//  UVReverbViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//

import UIKit
import AVFoundation
import ReactiveCocoa
import ReactiveSwift

class UVReverbViewController: UIViewController {

    private struct Constants {
        static let reuseIdentifier = "cell"
        static let singlePresetTableTag = 1
        static let allPresetsTableTag = 2
    }

    private let preset: MutableProperty<UVReverbPresset> = MutableProperty(.mediumRoom)

    @IBOutlet weak var wetDryCurrentValueLabel: UILabel!
    @IBOutlet weak var wetDrySlider: UISlider!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var mainView: UIView!

    @IBOutlet private weak var presetTableView: UITableView!
    @IBOutlet private weak var allPresetsTableView: UITableView!

    @IBOutlet private var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var allPresetsTableViewLeadingConstraint: NSLayoutConstraint!
}

// MARK: - Public interface

extension UVReverbViewController {
    static func instantiate() -> UVReverbViewController {
        UVReverbViewController(nibName: "UVReverbViewController", bundle: nil)
    }
}

// MARK: - UIViewController overrides

extension UVReverbViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        setupTableViews()
    }
}

// MARK: - Private interface

private extension UVReverbViewController {
    func bindViews() {
        wetDryCurrentValueLabel.reactive.text <~ wetDrySlider.reactive.values.map({ "\($0)%" })
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

enum UVReverbPresset: String, CaseIterable {
    case smallRoom = "Small Room"
    case mediumRoom = "Medium Room"
    case largeRoom = "Large Room"
    case mediumHall = "Medium Hall"
    case largeHall = "Large Hall"
    case plate = "Plate"
    case mediumChamber = "Medium Chamber"
    case largeChamber = "Large Chamber"
    case cathedral = "Cathedral"
    case largeRoom2 = "Large Room (2)"
    case mediumHall2 = "Medium Hall (2)"
    case mediumHall3 = "Medium Hall (3)"
    case largeHall2 = "Large Hall (2)"

    var representation: AVAudioUnitReverbPreset {
        switch self {
        case .smallRoom:
            return .smallRoom
        case .mediumRoom:
            return .mediumRoom
        case .largeRoom:
            return .largeRoom
        case .mediumHall:
            return .mediumHall
        case .largeHall:
            return .largeHall
        case .plate:
            return .plate
        case .mediumChamber:
            return .mediumChamber
        case .largeChamber:
            return .largeChamber
        case .cathedral:
            return .cathedral
        case .largeRoom2:
            return .largeRoom2
        case .mediumHall2:
            return .mediumHall2
        case .mediumHall3:
            return .mediumHall3
        case .largeHall2:
            return .largeHall2
        }
    }
}

extension AVAudioUnitReverbPreset {
    init(_ type: UVReverbPresset) {
        switch type {
        case .smallRoom:
            self = .smallRoom
        case .mediumRoom:
            self = .mediumRoom
        case .largeRoom:
            self = .largeRoom
        case .mediumHall:
            self = .mediumHall
        case .largeHall:
            self = .largeHall
        case .plate:
            self = .plate
        case .mediumChamber:
            self = .mediumChamber
        case .largeChamber:
            self = .largeChamber
        case .cathedral:
            self = .cathedral
        case .largeRoom2:
            self = .largeRoom2
        case .mediumHall2:
            self = .mediumHall2
        case .mediumHall3:
            self = .mediumHall3
        case .largeHall2:
            self = .largeHall2
        }
    }
}
