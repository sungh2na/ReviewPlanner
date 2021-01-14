//
//  UsedInfo+CoreDataProperties.swift
//  
//
//  Created by Y on 2021/01/14.
//
//

import Foundation
import CoreData


extension UsedInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsedInfo> {
        return NSFetchRequest<UsedInfo>(entityName: "UsedInfo")
    }

    @NSManaged public var intervals: [Int]?
    @NSManaged public var holidays: [String]?

}
