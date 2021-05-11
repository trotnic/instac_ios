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

struct UVProjectModel {
    var name: String
    var tracks: [UVTrackModel] = []
}

struct UVTrackModel {
    let project: String
    var name: String
    
    let isOn_EQ: Bool
    let globalGain_EQ: Float
    
    let isOn_Dist: Bool
    let preGain_Dist: Float
    let wetDryMix_Dist: Float
    let preset_Dist: Int16
    
    let isOn_Del: Bool
    let delayTime_Del: Float
    let feedback_Del: Float
    let lowPassCutoff_Del: Float
    let wetDryMix_Del: Float
    
    let isOn_Rev: Bool
    let wetDryMix_Rev: Float
    let preset_Rev: Int16

//    init(project: String, name: String, isOn: Bool = true, volume: Float = 0.5) {
//        self.project = project
//        self.name = name
//        self.url = url
//        self.isOn = MutableProperty(isOn)
//        self.volume = MutableProperty(volume)
//
//        self.isOn.signal.observeValues({ print($0) })
//    }
}
