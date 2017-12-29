//
//  DinnerItems+CoreDataClass.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 28/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(DinnerItems)
public class DinnerItems: NSManagedObject {
    
    // enum with dinnerItem Categories
    enum DinnerItemCategory: String {
        case Starter = "Starter"
        case Main = "Main Course"
        case Dessert = "Dessert"
        case Apperitive = "Apperitive"
        case White = "White Wine"
        case Red = "Red Wine"
        case Amuse = "Amuse"
        
    }
    // fetch the dinnerItems in Core Data
    func fetchDinnerItems(managedContext: NSManagedObjectContext ) -> [DinnerItems]? {
        let itemListFetchRequest : NSFetchRequest<DinnerItems> = DinnerItems.fetchRequest()
        itemListFetchRequest.predicate = NSPredicate(value: true)
        let coreDinnerItems:[DinnerItems]?
        do {
            coreDinnerItems = try managedContext.fetch(itemListFetchRequest)
        } catch let error as NSError {
            print ("Fetch error: \(error), description \(error.userInfo)")
            return nil
        }
        return coreDinnerItems
    }
    
    
}
extension DinnerItemTableViewController {
    
    // fetch DinnerItems in CloudKit using a CKQuery
    func fetchDinnerItemsFromCloudKit() {
        var fetchedItems : [DinnerItem] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DinnerItem", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = { record in
            let dinnerItem = DinnerItem(from: record)
            fetchedItems.append(dinnerItem)
        }
        operation.queryCompletionBlock = { cursor, error in
            if let error = error {
            print ("error, \(error)")
            }
            self.dinnerItems = fetchedItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.container.publicCloudDatabase.add(operation)
    }

}
