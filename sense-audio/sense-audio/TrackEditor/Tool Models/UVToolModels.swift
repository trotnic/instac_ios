//
//  UVToolModels.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      10.05.2021
//

import AVFoundation
import ReactiveSwift


final class UVToolbox {
    let equalizer: UVEqualizer = UVEqualizer()
    let distortion: UVDistortion = UVDistortion()
    let delay: UVDelay = UVDelay()
    let reverb: UVReverb = UVReverb()
}

final class UVEqualizer {
    let isOn: MutableProperty<Bool> = MutableProperty(false)
    
    let globalGain: MutableProperty<Float> = MutableProperty(0)
}

final class UVDistortion {
    let isOn: MutableProperty<Bool> = MutableProperty(false)
    
    let preGain: MutableProperty<Float> = MutableProperty(-6)
    let wetDryMix: MutableProperty<Float> = MutableProperty(50)
    let preset: MutableProperty<AVAudioUnitDistortionPreset> = MutableProperty(.drumsBitBrush)
}

final class UVDelay {
    let isOn: MutableProperty<Bool> = MutableProperty(false)
    
    let delayTime: MutableProperty<TimeInterval> = MutableProperty(1)
    let feedback: MutableProperty<Float> = MutableProperty(0)
    let lowPassCutoff: MutableProperty<Float> = MutableProperty(15000)
    let wetDryMix: MutableProperty<Float> = MutableProperty(100)
}

final class UVReverb {
    let isOn: MutableProperty<Bool> = MutableProperty(false)
    
    let wetDryMix: MutableProperty<Float> = MutableProperty(0)
    let preset: MutableProperty<AVAudioUnitReverbPreset> = MutableProperty(.mediumHall)
}
