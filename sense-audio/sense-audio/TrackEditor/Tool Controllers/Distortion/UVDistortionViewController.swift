//
//  UVDistortionViewController.swift
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

class UVDistortionViewController: UIViewController {

    private struct Constants {
        static let reuseIdentifier = "cell"
        static let singlePresetTableTag = 1
        static let allPresetsTableTag = 2
    }

    private let preset: MutableProperty<UVDistortionPreset> = MutableProperty(.drumsLoFi)

    @IBOutlet private weak var preGainSlider: UISlider!
    @IBOutlet private weak var preGainCurrentValueLabel: UILabel!
    @IBOutlet private weak var wetDryMixSlider: UISlider!
    @IBOutlet private weak var wetDryMixCurrentValueLabel: UILabel!

    @IBOutlet private weak var presetTableView: UITableView!
    @IBOutlet private weak var allPresetsTableView: UITableView!

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private var mainViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var allPresetsTableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var saveButton: UIButton!
}

// MARK: - Public interface

extension UVDistortionViewController {
    static func instantiate() -> UVDistortionViewController {
        UVDistortionViewController(nibName: "UVDistortionViewController", bundle: nil)
    }
}

// MARK: - UIViewController overrides

extension UVDistortionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        setupTableViews()
    }
}

// MARK: - Private interface

private extension UVDistortionViewController {
    func bindViews() {
        preGainCurrentValueLabel.reactive.text <~ preGainSlider.reactive.values.map({ "\($0)db" })
        wetDryMixCurrentValueLabel.reactive.text <~ wetDryMixSlider.reactive.values.map({ "\($0)%" })
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

enum UVDistortionPreset: String, CaseIterable {
    case drumsBitBrush = "Drums Bit Brush"
    case drumsBufferBeats = "Drums Buffer Beats"
    case drumsLoFi = "Drums Lo-Fi"
    case multiBrokenSpeaker = "Multi Broken Speaker"
    case multiCellphoneConcert = "Multi Cellphone Concert"
    case multiDecimated1 = "Multi Decimated (1)"
    case multiDecimated2 = "Multi Decimated (2)"
    case multiDecimated3 = "Multi Decimated (3)"
    case multiDecimated4 = "Multi Decimated (4)"
    case multiDistortedFunk = "Multi Distorted Funk"
    case multiDistortedCubed = "Multi Distorted Cubed"
    case multiDistortedSquared = "Multi Distorted Squared"
    case multiEcho1 = "Multi Echo (1)"
    case multiEcho2 = "Multi Echo (2)"
    case multiEchoTight1 = "Multi Echo Tight (1)"
    case multiEchoTight2 = "Multi Echo Tight (2)"
    case multiEverythingIsBroken = "Multi Everything Is Broken"
    case speechAlienChatter = "Speech Alien Chatter"
    case speechCosmicInterference = "Speech Cosmic Interference"
    case speechGoldenPi = "Speech Golden Pi"
    case speechRadioTower = "Speech Radio Tower"
    case speechWaves = "Speech Waves"

    var representation: AVAudioUnitDistortionPreset {
        switch self {
        case .drumsBitBrush:
            return .drumsBitBrush
        case .drumsBufferBeats:
            return .drumsBufferBeats
        case .drumsLoFi:
            return .drumsLoFi
        case .multiBrokenSpeaker:
            return .multiBrokenSpeaker
        case .multiCellphoneConcert:
            return .multiCellphoneConcert
        case .multiDecimated1:
            return .multiDecimated1
        case .multiDecimated2:
            return .multiDecimated2
        case .multiDecimated3:
            return .multiDecimated3
        case .multiDecimated4:
            return .multiDecimated4
        case .multiDistortedFunk:
            return .multiDistortedFunk
        case .multiDistortedCubed:
            return .multiDistortedCubed
        case .multiDistortedSquared:
            return .multiDistortedSquared
        case .multiEcho1:
            return .multiEcho1
        case .multiEcho2:
            return .multiEcho2
        case .multiEchoTight1:
            return .multiEchoTight1
        case .multiEchoTight2:
            return .multiEchoTight2
        case .multiEverythingIsBroken:
            return .multiEverythingIsBroken
        case .speechAlienChatter:
            return .speechAlienChatter
        case .speechCosmicInterference:
            return .speechCosmicInterference
        case .speechGoldenPi:
            return .speechGoldenPi
        case .speechRadioTower:
            return .speechRadioTower
        case .speechWaves:
            return .speechWaves
        }
    }
}

extension AVAudioUnitDistortionPreset {
    init(_ type: UVDistortionPreset) {
        switch type {
        case .drumsBitBrush:
            self = .drumsBitBrush
        case .drumsBufferBeats:
            self = .drumsBufferBeats
        case .drumsLoFi:
            self = .drumsLoFi
        case .multiBrokenSpeaker:
            self = .multiBrokenSpeaker
        case .multiCellphoneConcert:
            self = .multiCellphoneConcert
        case .multiDecimated1:
            self = .multiDecimated1
        case .multiDecimated2:
            self = .multiDecimated2
        case .multiDecimated3:
            self = .multiDecimated3
        case .multiDecimated4:
            self = .multiDecimated4
        case .multiDistortedCubed:
            self = .multiDistortedCubed
        case .multiDistortedSquared:
            self = .multiDistortedSquared
        case .multiDistortedFunk:
            self = .multiDistortedFunk
        case .multiEcho1:
            self = .multiEcho1
        case .multiEcho2:
            self = .multiEcho2
        case .multiEchoTight1:
            self = .multiEchoTight1
        case .multiEchoTight2:
            self = .multiEchoTight2
        case .multiEverythingIsBroken:
            self = .multiEverythingIsBroken
        case .speechAlienChatter:
            self = .speechAlienChatter
        case .speechCosmicInterference:
            self = .speechCosmicInterference
        case .speechGoldenPi:
            self = .speechGoldenPi
        case .speechRadioTower:
            self = .speechRadioTower
        case .speechWaves:
            self = .speechWaves
        }
    }
}
