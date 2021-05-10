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
