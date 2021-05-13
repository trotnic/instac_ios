//
//  UVDistortionPreset.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      10.05.2021
//

import AVFoundation

enum UVDistortionPreset: String, CaseIterable {
    case drumsBitBrush = "Drums Bit Brush"
    case drumsBufferBeats = "Drums Buffer Beats"
    case drumsLoFi = "Drums Lo-Fi"
    case multiBrokenSpeaker = "Multi Broken Speaker"
    case multiCellphoneConcert = "Multi Cellphone Concert"
    case multiDecimated1 = "Multi Decimated (1)"
    case multiDecimated2 = "Multi Decimated (2)"
    case multiDecimated3 = "Multi Decimated (3)"
    case multiDecimated4 = "Multi Decimated (4)"
    case multiDistortedFunk = "Multi Distorted Funk"
    case multiDistortedCubed = "Multi Distorted Cubed"
    case multiDistortedSquared = "Multi Distorted Squared"
    case multiEcho1 = "Multi Echo (1)"
    case multiEcho2 = "Multi Echo (2)"
    case multiEchoTight1 = "Multi Echo Tight (1)"
    case multiEchoTight2 = "Multi Echo Tight (2)"
    case multiEverythingIsBroken = "Multi Everything Is Broken"
    case speechAlienChatter = "Speech Alien Chatter"
    case speechCosmicInterference = "Speech Cosmic Interference"
    case speechGoldenPi = "Speech Golden Pi"
    case speechRadioTower = "Speech Radio Tower"
    case speechWaves = "Speech Waves"

    var representation: AVAudioUnitDistortionPreset {
        switch self {
        case .drumsBitBrush:
            return .drumsBitBrush
        case .drumsBufferBeats:
            return .drumsBufferBeats
        case .drumsLoFi:
            return .drumsLoFi
        case .multiBrokenSpeaker:
            return .multiBrokenSpeaker
        case .multiCellphoneConcert:
            return .multiCellphoneConcert
        case .multiDecimated1:
            return .multiDecimated1
        case .multiDecimated2:
            return .multiDecimated2
        case .multiDecimated3:
            return .multiDecimated3
        case .multiDecimated4:
            return .multiDecimated4
        case .multiDistortedFunk:
            return .multiDistortedFunk
        case .multiDistortedCubed:
            return .multiDistortedCubed
        case .multiDistortedSquared:
            return .multiDistortedSquared
        case .multiEcho1:
            return .multiEcho1
        case .multiEcho2:
            return .multiEcho2
        case .multiEchoTight1:
            return .multiEchoTight1
        case .multiEchoTight2:
            return .multiEchoTight2
        case .multiEverythingIsBroken:
            return .multiEverythingIsBroken
        case .speechAlienChatter:
            return .speechAlienChatter
        case .speechCosmicInterference:
            return .speechCosmicInterference
        case .speechGoldenPi:
            return .speechGoldenPi
        case .speechRadioTower:
            return .speechRadioTower
        case .speechWaves:
            return .speechWaves
        }
    }
}

extension AVAudioUnitDistortionPreset {
    init(_ type: UVDistortionPreset) {
        switch type {
        case .drumsBitBrush:
            self = .drumsBitBrush
        case .drumsBufferBeats:
            self = .drumsBufferBeats
        case .drumsLoFi:
            self = .drumsLoFi
        case .multiBrokenSpeaker:
            self = .multiBrokenSpeaker
        case .multiCellphoneConcert:
            self = .multiCellphoneConcert
        case .multiDecimated1:
            self = .multiDecimated1
        case .multiDecimated2:
            self = .multiDecimated2
        case .multiDecimated3:
            self = .multiDecimated3
        case .multiDecimated4:
            self = .multiDecimated4
        case .multiDistortedCubed:
            self = .multiDistortedCubed
        case .multiDistortedSquared:
            self = .multiDistortedSquared
        case .multiDistortedFunk:
            self = .multiDistortedFunk
        case .multiEcho1:
            self = .multiEcho1
        case .multiEcho2:
            self = .multiEcho2
        case .multiEchoTight1:
            self = .multiEchoTight1
        case .multiEchoTight2:
            self = .multiEchoTight2
        case .multiEverythingIsBroken:
            self = .multiEverythingIsBroken
        case .speechAlienChatter:
            self = .speechAlienChatter
        case .speechCosmicInterference:
            self = .speechCosmicInterference
        case .speechGoldenPi:
            self = .speechGoldenPi
        case .speechRadioTower:
            self = .speechRadioTower
        case .speechWaves:
            self = .speechWaves
        }
    }
    
    init(_ pos: Int16) {
        switch pos {
        case 0:
            self = .drumsBitBrush
        case 1:
            self = .drumsBufferBeats
        case 2:
            self = .drumsLoFi
        case 3:
            self = .multiBrokenSpeaker
        case 4:
            self = .multiCellphoneConcert
        case 5:
            self = .multiDecimated1
        case 6:
            self = .multiDecimated2
        case 7:
            self = .multiDecimated3
        case 8:
            self = .multiDecimated4
        case 9:
            self = .multiDistortedCubed
        case 10:
            self = .multiDistortedSquared
        case 11:
            self = .multiDistortedFunk
        case 12:
            self = .multiEcho1
        case 13:
            self = .multiEcho2
        case 14:
            self = .multiEchoTight1
        case 15:
            self = .multiEchoTight2
        case 16:
            self = .multiEverythingIsBroken
        case 17:
            self = .speechAlienChatter
        case 18:
            self = .speechCosmicInterference
        case 19:
            self = .speechGoldenPi
        case 20:
            self = .speechRadioTower
        case 21:
            self = .speechWaves
        default:
            fatalError()
        }
    }
    
    var representation: UVDistortionPreset {
        switch self {
        case .drumsBitBrush:
            return .drumsBitBrush
        case .drumsBufferBeats:
            return .drumsBufferBeats
        case .drumsLoFi:
            return .drumsLoFi
        case .multiBrokenSpeaker:
            return .multiBrokenSpeaker
        case .multiCellphoneConcert:
            return .multiCellphoneConcert
        case .multiDecimated1:
            return .multiDecimated1
        case .multiDecimated2:
            return .multiDecimated2
        case .multiDecimated3:
            return .multiDecimated3
        case .multiDecimated4:
            return .multiDecimated4
        case .multiDistortedFunk:
            return .multiDistortedFunk
        case .multiDistortedCubed:
            return .multiDistortedCubed
        case .multiDistortedSquared:
            return .multiDistortedSquared
        case .multiEcho1:
            return .multiEcho1
        case .multiEcho2:
            return .multiEcho2
        case .multiEchoTight1:
            return .multiEchoTight1
        case .multiEchoTight2:
            return .multiEchoTight2
        case .multiEverythingIsBroken:
            return .multiEverythingIsBroken
        case .speechAlienChatter:
            return .speechAlienChatter
        case .speechCosmicInterference:
            return .speechCosmicInterference
        case .speechGoldenPi:
            return .speechGoldenPi
        case .speechRadioTower:
            return .speechRadioTower
        case .speechWaves:
            return .speechWaves
        @unknown default:
            fatalError()
        }
    }
}
