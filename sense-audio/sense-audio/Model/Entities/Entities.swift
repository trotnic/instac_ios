//
//  Entities.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      08.05.2021
//

import Foundation
import ReactiveSwift

final class UVTrackModel {
    let project: String
    var name: String
    var url: URL

    let isOn: MutableProperty<Bool>
    let volume: MutableProperty<Float>

    init(project: String, name: String, url: URL, isOn: Bool = true, volume: Float = 0.5) {
        self.project = project
        self.name = name
        self.url = url
        self.isOn = MutableProperty(isOn)
        self.volume = MutableProperty(volume)

        self.isOn.signal.observeValues({ print($0) })
    }
}
