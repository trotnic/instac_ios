//
//  UVPipelineTrackCollectionCell.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      01.05.2021
//

import UIKit

class UVPipelineTrackCollectionCell: UICollectionViewCell {

    private struct Constants {
        static let nibName = "UVPipelineTrackCollectionCell"
    }

    static func instantiateNib() -> UINib {
        return UINib(nibName: Constants.nibName, bundle: nil)
    }
}
