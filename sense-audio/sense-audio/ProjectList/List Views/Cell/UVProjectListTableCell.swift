//
//  UVProjectListTableCell.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      11.05.2021
//

import UIKit

class UVProjectListTableCell: UITableViewCell {

    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
}

// MARK: - Public Interface

extension UVProjectListTableCell {
    static func instantiateNib() -> UINib {
        return UINib(nibName: "UVProjectListTableCell", bundle: nil)
    }
}

// MARK: - UITableViewCell overrides

extension UVProjectListTableCell {
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
