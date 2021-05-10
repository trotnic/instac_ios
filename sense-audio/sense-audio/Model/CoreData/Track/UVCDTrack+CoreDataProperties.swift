//
//  UVCDTrack+CoreDataProperties.swift
//
//  Project: 
// 
//  Author:  Uladzislau Volchyk
//  On:      09.05.2021
//
//

import Foundation
import CoreData

extension UVCDTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UVCDTrack> {
        return NSFetchRequest<UVCDTrack>(entityName: "UVCDTrack")
    }

    @NSManaged public var name: Float
    @NSManaged public var url: URL?
    @NSManaged public var volume: Float?
    @NSManaged public var isOn: Bool

}
