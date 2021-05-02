//
//  UVButton.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import UIKit

class UVButton: UIButton {

    init() {
        super.init(frame: .zero)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupAppearance() {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
    }
}
