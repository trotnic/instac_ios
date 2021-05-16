//
//  UVCDProject+CoreDataProperties.swift
//
//  Project: 
// 
//  Author:  Uladzislau Volchyk
//  On:      11.05.2021
//
//

import Foundation
import CoreData

extension UVCDProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UVCDProject> {
        return NSFetchRequest<UVCDProject>(entityName: "UVCDProject")
    }

    @NSManaged public var name: String?
    @NSManaged public var tracks: [UVCDTrack?]?

}
