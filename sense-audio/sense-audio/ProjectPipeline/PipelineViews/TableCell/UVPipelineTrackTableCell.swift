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

    lazy var switcher: Property<Bool> = Property(initial: false, then: trackSwitch.reactive.isOnValues)

    @IBOutlet weak var trackSwitch: UISwitch!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    static func instantiateNib() -> UINib {
        return UINib(nibName: "UVPipelineTrackTableCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

    }

}
