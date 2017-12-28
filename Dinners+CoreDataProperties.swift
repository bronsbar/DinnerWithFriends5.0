//
//  Dinners+CoreDataProperties.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 28/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//
//

import Foundation
import CoreData


extension Dinners {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dinners> {
        return NSFetchRequest<Dinners>(entityName: "Dinners")
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var date: NSDate?
    @NSManaged public var friends: NSObject?
    @NSManaged public var image: NSData?
    @NSManaged public var lastUpdated: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var rating: Int16
    @NSManaged public var recordID: UUID?
    @NSManaged public var recordName: String?
    @NSManaged public var dinneritems: NSSet?

}

// MARK: Generated accessors for dinneritems
extension Dinners {

    @objc(addDinneritemsObject:)
    @NSManaged public func addToDinneritems(_ value: DinnerItems)

    @objc(removeDinneritemsObject:)
    @NSManaged public func removeFromDinneritems(_ value: DinnerItems)

    @objc(addDinneritems:)
    @NSManaged public func addToDinneritems(_ values: NSSet)

    @objc(removeDinneritems:)
    @NSManaged public func removeFromDinneritems(_ values: NSSet)

}
