//
//  UIHelpers.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      10.05.2021
//

import UIKit

extension UIStackView {
    /// Removes all arranged subviews and their constraints from the view.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
        }
    }
    
    func removeArrangedSubviews(_ view: UIView) {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
    }
}

extension String {
    private enum TimeConstant {
        static let secsPerMin = 60
        static let secsPerHour = TimeConstant.secsPerMin * 60
    }
    
    
    static func formatted(time: Float) -> String {
        var secs = Int(ceil(time))
        var hours = 0
        var mins = 0
        
        if secs > TimeConstant.secsPerHour {
            hours = secs / TimeConstant.secsPerHour
            secs -= hours * TimeConstant.secsPerHour
        }
        
        if secs > TimeConstant.secsPerMin {
            mins = secs / TimeConstant.secsPerMin
            secs -= mins * TimeConstant.secsPerMin
        }
        
        var formattedString = ""
        if hours > 0 {
            formattedString = "\(String(format: "%02d", hours)):"
        }
        formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
        return formattedString
    }
}

extension UIImage {
    enum Asset: String {
        case save = "file-check"
        case newTrack = "new-section"
        case pause
        case play
        case record
        case stop
        case trash
    }
    
    convenience init?(_ asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
