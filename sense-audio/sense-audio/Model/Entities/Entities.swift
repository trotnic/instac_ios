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

    let volume: MutableProperty<Float>

    init(project: String, name: String, url: URL, volume: Float) {
        self.project = project
        self.name = name
        self.url = url
        self.volume = MutableProperty(volume)
    }
}
