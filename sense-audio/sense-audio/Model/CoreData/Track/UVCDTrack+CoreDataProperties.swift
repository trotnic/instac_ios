//
//  UVCDTrack+CoreDataProperties.swift
//
//  Project: 
// 
//  Author:  Uladzislau Volchyk
//  On:      11.05.2021
//
//

import Foundation
import CoreData

extension UVCDTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UVCDTrack> {
        return NSFetchRequest<UVCDTrack>(entityName: "UVCDTrack")
    }

    @NSManaged public var isOn_EQ: Bool
    @NSManaged public var globalGain_EQ: Float
    @NSManaged public var isOn_Dist: Bool
    @NSManaged public var preGain_Dist: Float
    @NSManaged public var wetDryMix_Dist: Float
    @NSManaged public var preset_Dist: Int16
    @NSManaged public var isOn_Del: Bool
    @NSManaged public var delayTime_Del: Float
    @NSManaged public var feedback_Del: Float
    @NSManaged public var lowPassCutoff_Del: Float
    @NSManaged public var wetDryMix_Del: Float
    @NSManaged public var isOn_Rev: Bool
    @NSManaged public var wetDryMix_Rev: Float
    @NSManaged public var preset_Rev: Int16
    @NSManaged public var name: String?
    @NSManaged public var project: UVCDProject?

}
