//
//  UVAudioSettings.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      08.05.2021
//

import AVFoundation
import ReactiveSwift

protocol UVAudioSettings {

}

extension UVAudioSettings {
    var format: AVAudioFormat {
        AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 1, interleaved: false)!
    }

    var bufferSize: AVAudioFrameCount { 4096 }
}

extension DispatchQueue {
    static let audioQueue = DispatchQueue(label: "com.uvolchyk.audio_gcd", qos: .userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)
}

extension QueueScheduler {
    static let audio = QueueScheduler(qos: .userInitiated, name: "com.uvolchyk.audio", targeting: .audioQueue)
}
