//
//  DinnerItems+CoreDataProperties.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 29/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//
//

import Foundation
import CoreData


extension DinnerItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DinnerItems> {
        return NSFetchRequest<DinnerItems>(entityName: "DinnerItems")
    }

    @NSManaged public var added: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var privateUse: Bool
    @NSManaged public var rating: Int16
    @NSManaged public var recordID: UUID?
    @NSManaged public var recordName: String?
    @NSManaged public var url: URL?
    @NSManaged public var category: String?
    @NSManaged public var dinners: NSSet?

}

// MARK: Generated accessors for dinners
extension DinnerItems {

    @objc(addDinnersObject:)
    @NSManaged public func addToDinners(_ value: Dinners)

    @objc(removeDinnersObject:)
    @NSManaged public func removeFromDinners(_ value: Dinners)

    @objc(addDinners:)
    @NSManaged public func addToDinners(_ values: NSSet)

    @objc(removeDinners:)
    @NSManaged public func removeFromDinners(_ values: NSSet)

}
