//
//  Dinner.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 20/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI


struct Dinner {
    var name : String
    var friends : [CNMutableContact]
    var date : Data
    var starter : [DinnerItem]?
    var mainCourse : [DinnerItem]?
    var dessert : [DinnerItem]?
    var amuse : [DinnerItem]?
    var apperitive : [DinnerItem]?
    var wine : [DinnerItem]?
    var image : UIImage?
    var notes : String?
    var rating : Int?
    
}
