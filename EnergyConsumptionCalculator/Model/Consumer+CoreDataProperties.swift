//
//  Consumer+CoreDataProperties.swift
//  
//
//  Created by M.Ali on 20/08/2022.
//
//

import Foundation
import CoreData


extension Consumer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Consumer> {
        return NSFetchRequest<Consumer>(entityName: "Consumer")
    }

    @NSManaged public var cost1: Int16
    @NSManaged public var cost2: Int16
    @NSManaged public var cost3: Int16
    @NSManaged public var id: Int32
    @NSManaged public var reading1: Int16
    @NSManaged public var reading2: Int16
    @NSManaged public var reading3: Int16

}
