//
//  UVPipelineTrackTableCell.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      08.05.2021
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UVPipelineTrackTableCell: UITableViewCell {
    @IBOutlet weak var trackSwitch: UISwitch!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    lazy var switcher: Property<Bool> = Property(initial: false, then: trackSwitch.reactive.isOnValues)
}

// MARK: - Public interface

extension UVPipelineTrackTableCell {

    static func instantiateNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

// MARK: - UITableViewCell overrides

extension UVPipelineTrackTableCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
}
