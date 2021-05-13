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
    private let model: UVTrackModel

    let equalizer: UVEqualizer
    let distortion: UVDistortion
    let delay: UVDelay
    let reverb: UVReverb

    init(model: UVTrackModel) {
        self.model = model

        self.equalizer = UVEqualizer(isOn: model.isOn_EQ, gain: model.globalGain_EQ)
        self.distortion = UVDistortion(isOn: model.isOn_Dist, gain: model.preGain_Dist, wetDry: model.wetDryMix_Dist, preset: .init(model.preset_Dist))
        self.delay = UVDelay(isOn: model.isOn_Del, delay: model.delayTime_Del, feedback: model.feedback_Del, cutoff: model.lowPassCutoff_Del, wetDry: model.wetDryMix_Del)
        self.reverb = UVReverb(isOn: model.isOn_Rev, wetDry: model.wetDryMix_Rev, preset: .init(model.preset_Rev))
    }

    var trackModel: UVTrackModel {
        UVTrackModel(id: model.id,
                     projectId: model.projectId,
                     name: model.name,
                     isOn_EQ: equalizer.isOn.value,
                     globalGain_EQ: equalizer.globalGain.value,
                     isOn_Dist: distortion.isOn.value,
                     preGain_Dist: distortion.preGain.value,
                     wetDryMix_Dist: distortion.wetDryMix.value,
                     preset_Dist: distortion.preset.value.numeric,
                     isOn_Del: delay.isOn.value,
                     delayTime_Del: Float(delay.delayTime.value),
                     feedback_Del: delay.feedback.value,
                     lowPassCutoff_Del: delay.lowPassCutoff.value,
                     wetDryMix_Del: delay.wetDryMix.value,
                     isOn_Rev: reverb.isOn.value,
                     wetDryMix_Rev: reverb.wetDryMix.value,
                     preset_Rev: reverb.preset.value.numeric)
    }
}

final class UVEqualizer {
    let isOn: MutableProperty<Bool>

    let globalGain: MutableProperty<Float>

    init(isOn: Bool, gain: Float) {
        self.isOn = MutableProperty(isOn)
        self.globalGain = MutableProperty(gain)
    }
}

final class UVDistortion {
    let isOn: MutableProperty<Bool>

    let preGain: MutableProperty<Float>
    let wetDryMix: MutableProperty<Float>
    let preset: MutableProperty<AVAudioUnitDistortionPreset>

    init(isOn: Bool, gain: Float, wetDry: Float, preset: AVAudioUnitDistortionPreset) {
        self.isOn = MutableProperty(isOn)
        self.preGain = MutableProperty(gain)
        self.wetDryMix = MutableProperty(wetDry)
        self.preset = MutableProperty(preset)
    }
}

final class UVDelay {
    let isOn: MutableProperty<Bool>

    let delayTime: MutableProperty<TimeInterval>
    let feedback: MutableProperty<Float>
    let lowPassCutoff: MutableProperty<Float>
    let wetDryMix: MutableProperty<Float>

    init(isOn: Bool, delay: Float, feedback: Float, cutoff: Float, wetDry: Float) {
        self.isOn = MutableProperty(isOn)
        self.delayTime = MutableProperty(TimeInterval(delay))
        self.feedback = MutableProperty(feedback)
        self.lowPassCutoff = MutableProperty(cutoff)
        self.wetDryMix = MutableProperty(wetDry)
    }
}

final class UVReverb {
    let isOn: MutableProperty<Bool>

    let wetDryMix: MutableProperty<Float>
    let preset: MutableProperty<AVAudioUnitReverbPreset>

    init(isOn: Bool, wetDry: Float, preset: AVAudioUnitReverbPreset) {
        self.isOn = MutableProperty(isOn)
        self.wetDryMix = MutableProperty(wetDry)
        self.preset = MutableProperty(preset)
    }
}
