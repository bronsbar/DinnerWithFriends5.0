//
//  BackgroundPictures+CoreDataProperties.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 17/01/18.
//  Copyright © 2018 Bart Bronselaer. All rights reserved.
//
//

import Foundation
import CoreData


extension BackgroundPictures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackgroundPictures> {
        return NSFetchRequest<BackgroundPictures>(entityName: "BackgroundPictures")
    }

    @NSManaged public var ckChangeTag: String?
    @NSManaged public var ckDatabase: String?
    @NSManaged public var ckZone: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var modified: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var pictureName: String?
    @NSManaged public var recordName: String?
    @NSManaged public var recordType: String?
    @NSManaged public var metaData: NSData?

}
