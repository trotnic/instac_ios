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

// MARK: - Project

struct UVProjectModel {
    let id: UUID
    var name: String
    var tracks: [UVTrackModel] = []
}

extension UVProjectModel {
    init(name: String) {
        self.init(id: UUID(), name: name)
    }
}

extension UVProjectModel {
    init(_ model: CDProject) {
        self.init(id: model.id!, name: model.name!, tracks: model.tracks!.map({ UVTrackModel($0 as! CDTrack) }))
    }
}

extension CDProject {
    func attach(_ project: UVProjectModel) {
        name = project.name
        id = project.id
    }
}

// MARK: - Track

struct UVTrackModel {
    let id: UUID

    let projectId: UUID
    var name: String

    var isOn_EQ: Bool
    var globalGain_EQ: Float

    var isOn_Dist: Bool
    var preGain_Dist: Float
    var wetDryMix_Dist: Float
    var preset_Dist: Int16

    var isOn_Del: Bool
    var delayTime_Del: Float
    var feedback_Del: Float
    var lowPassCutoff_Del: Float
    var wetDryMix_Del: Float

    var isOn_Rev: Bool
    var wetDryMix_Rev: Float
    var preset_Rev: Int16
}

extension UVTrackModel {
    init(project: UUID, name: String) {
        self.init(id: UUID(),
                  projectId: project,
                  name: name,

                  isOn_EQ: false,
                  globalGain_EQ: 0,

                  isOn_Dist: false,
                  preGain_Dist: -6,
                  wetDryMix_Dist: 50,
                  preset_Dist: 0,

                  isOn_Del: false,
                  delayTime_Del: 1,
                  feedback_Del: 50,
                  lowPassCutoff_Del: 15000,
                  wetDryMix_Del: 100,

                  isOn_Rev: false,
                  wetDryMix_Rev: 0,
                  preset_Rev: 3)
    }

    init(_ model: CDTrack) {
        self.init(id: model.id!,
                  projectId: model.project!.id!,
                  name: model.name!,
                  isOn_EQ: model.isOn_EQ,
                  globalGain_EQ: model.globalGain_EQ,
                  isOn_Dist: model.isOn_Dist,
                  preGain_Dist: model.preGain_Dist,
                  wetDryMix_Dist: model.wetDryMix_Dist,
                  preset_Dist: model.preset_Dist,
                  isOn_Del: model.isOn_Del,
                  delayTime_Del: model.delayTime_Del,
                  feedback_Del: model.feedback_Del,
                  lowPassCutoff_Del: model.lowPassCutoff_Del,
                  wetDryMix_Del: model.wetDryMix_Del,
                  isOn_Rev: model.isOn_Rev,
                  wetDryMix_Rev: model.wetDryMix_Rev,
                  preset_Rev: model.preset_Rev)
    }
}

extension CDTrack {
    func attach(_ track: UVTrackModel) {
        id = track.id
        name = track.name
        isOn_EQ = track.isOn_EQ
        globalGain_EQ = track.globalGain_EQ
        isOn_Dist = track.isOn_Dist
        preGain_Dist = track.preGain_Dist
        wetDryMix_Dist = track.wetDryMix_Dist
        preGain_Dist = track.preGain_Dist
        isOn_Del = track.isOn_Del
        delayTime_Del = track.delayTime_Del
        feedback_Del = track.feedback_Del
        lowPassCutoff_Del = track.lowPassCutoff_Del
        wetDryMix_Del = track.wetDryMix_Del
        isOn_Rev = track.isOn_Rev
        wetDryMix_Rev = track.wetDryMix_Rev
        preset_Rev = track.preset_Rev
    }
}
