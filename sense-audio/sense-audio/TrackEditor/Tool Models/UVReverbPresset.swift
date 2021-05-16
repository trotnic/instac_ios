//
//  UVReverbPresset.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      10.05.2021
//

import AVFoundation

enum UVReverbPresset: String, CaseIterable {
    case smallRoom = "Small Room"
    case mediumRoom = "Medium Room"
    case largeRoom = "Large Room"
    case mediumHall = "Medium Hall"
    case largeHall = "Large Hall"
    case plate = "Plate"
    case mediumChamber = "Medium Chamber"
    case largeChamber = "Large Chamber"
    case cathedral = "Cathedral"
    case largeRoom2 = "Large Room (2)"
    case mediumHall2 = "Medium Hall (2)"
    case mediumHall3 = "Medium Hall (3)"
    case largeHall2 = "Large Hall (2)"

    var representation: AVAudioUnitReverbPreset {
        switch self {
        case .smallRoom:
            return .smallRoom
        case .mediumRoom:
            return .mediumRoom
        case .largeRoom:
            return .largeRoom
        case .mediumHall:
            return .mediumHall
        case .largeHall:
            return .largeHall
        case .plate:
            return .plate
        case .mediumChamber:
            return .mediumChamber
        case .largeChamber:
            return .largeChamber
        case .cathedral:
            return .cathedral
        case .largeRoom2:
            return .largeRoom2
        case .mediumHall2:
            return .mediumHall2
        case .mediumHall3:
            return .mediumHall3
        case .largeHall2:
            return .largeHall2
        }
    }
}

extension AVAudioUnitReverbPreset {
    init(_ type: UVReverbPresset) {
        switch type {
        case .smallRoom:
            self = .smallRoom
        case .mediumRoom:
            self = .mediumRoom
        case .largeRoom:
            self = .largeRoom
        case .mediumHall:
            self = .mediumHall
        case .largeHall:
            self = .largeHall
        case .plate:
            self = .plate
        case .mediumChamber:
            self = .mediumChamber
        case .largeChamber:
            self = .largeChamber
        case .cathedral:
            self = .cathedral
        case .largeRoom2:
            self = .largeRoom2
        case .mediumHall2:
            self = .mediumHall2
        case .mediumHall3:
            self = .mediumHall3
        case .largeHall2:
            self = .largeHall2
        }
    }

    init(_ pos: Int16) {
        switch pos {
        case 0:
            self = .smallRoom
        case 1:
            self = .mediumRoom
        case 2:
            self = .largeRoom
        case 3:
            self = .mediumHall
        case 4:
            self = .largeHall
        case 5:
            self = .plate
        case 6:
            self = .mediumChamber
        case 7:
            self = .largeChamber
        case 8:
            self = .cathedral
        case 9:
            self = .largeRoom2
        case 10:
            self = .mediumHall2
        case 11:
            self = .mediumHall3
        case 12:
            self = .largeHall2
        default:
            fatalError()
        }
    }

    var representation: UVReverbPresset {
        switch self {
        case .smallRoom:
            return .smallRoom
        case .mediumRoom:
            return .mediumRoom
        case .largeRoom:
            return .largeRoom
        case .mediumHall:
            return .mediumHall
        case .largeHall:
            return .largeHall
        case .plate:
            return .plate
        case .mediumChamber:
            return .mediumChamber
        case .largeChamber:
            return .largeChamber
        case .cathedral:
            return .cathedral
        case .largeRoom2:
            return .largeRoom2
        case .mediumHall2:
            return .mediumHall2
        case .mediumHall3:
            return .mediumHall3
        case .largeHall2:
            return .largeHall2
        @unknown default:
            fatalError()
        }
    }

    var numeric: Int16 {
        switch self {
        case .smallRoom:
            return 0
        case .mediumRoom:
            return 1
        case .largeRoom:
            return 2
        case .mediumHall:
            return 3
        case .largeHall:
            return 4
        case .plate:
            return 5
        case .mediumChamber:
            return 6
        case .largeChamber:
            return 7
        case .cathedral:
            return 8
        case .largeRoom2:
            return 9
        case .mediumHall2:
            return 10
        case .mediumHall3:
            return 11
        case .largeHall2:
            return 12
        @unknown default:
            fatalError()
        }

    }
}
