//
//  DinnerItem.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 20/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


struct DinnerItem {
    var name : String
    var image : UIImage?
    var url : URL?
    var notes : String?
    var rating : Int?
    
    func convertDataToUIimage (inputdata data: Data) -> UIImage? {
        // nog uit te werken
        return nil
    }
   
    init (from record : CKRecord) {
        let name = record["name"] as! String
        self.name = name
        self.image = nil
        self.url = nil
        self.notes = nil
        self.rating = nil
    }
        
        
    
    }
