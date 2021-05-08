//
//  UVAudioSettings.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      08.05.2021
//

import AVFoundation

protocol UVAudioSettings {

}

extension UVAudioSettings {
    var format: AVAudioFormat {
        AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 1, interleaved: false)!
    }

    var bufferSize: AVAudioFrameCount { 4096 }
}
