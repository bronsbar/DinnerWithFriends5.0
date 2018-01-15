//
//  AppDelegate.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 20/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import UIKit
import CloudKit
import CoreData



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "Dinner With Friends")
    
    var dinnerPictures :[UIImage] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        
        
        // propagate the managedContext
        
        guard let tabBarController = window?.rootViewController as? UITabBarController else { print ("tabbarcontroller niet gevonden")
            return true
        }
        guard let navController = tabBarController.childViewControllers.first as? UINavigationController else {
            print ("navcontroller niet gevonden")
            return true
        }
        guard let viewController = navController.topViewController as? DinnerItemTableViewController else {
            print ("managedcontext not propagated")
            return true}
        
        guard let navController2 = tabBarController.childViewControllers[1] as? UINavigationController else {
            print("tweede navcontroller niet gevonden")
            return true
        }
        guard let viewController2 = navController2.topViewController as? DinnerCreatorViewController else {
            print( "dinnercreator controller niet gevonden")
            return true
        }
        
    
        viewController.coreDataStack = coreDataStack
        viewController2.coreDataStack = coreDataStack
        
        
        configureCloudKit()
        // if Core Data is empty, import the dinnerItems from Cloudkit
        importCloudKitDataIfNeeded(toUpdate: viewController)
        importCloudKitImages()
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        coreDataStack.saveContext()
    }
}

// MARK: - Helper Methods
extension AppDelegate {
    
    var container: CKContainer {
        return CKContainer(identifier: "iCloud.bart.bronselaer-me.com.DinnerWithFriends5-0")
    }
    
    private func configureCloudKit() {
        let container = CKContainer(identifier: "iCloud.bart.bronselaer-me.com.DinnerWithFriends5-0")
        container.privateCloudDatabase.fetchAllRecordZones { zones, error in
            guard let zones = zones, error == nil else {
                
                // error handling
                return
            }
            print ("I have these zones : \(zones)")
            for zones in zones {
                print (zones.zoneID.zoneName)
            }
        }
    }
    
    private func importCloudKitImages() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DinnerPicture", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = { record in
             if let asset = record.object(forKey: "picuture") as? CKAsset,
            let data = NSData(contentsOf: asset.fileURL),
                let image = UIImage(data: data as Data) {
                self.dinnerPictures.append(image)
                print(self.dinnerPictures.count)
            }
           
            }
      
        container.publicCloudDatabase.add(operation)
    }
    
    private func importCloudKitDataIfNeeded(toUpdate viewController: DinnerItemTableViewController) {
        
        let fetchRequest: NSFetchRequest<DinnerItems> = DinnerItems.fetchRequest()
        let count = try? coreDataStack.managedContext.count(for: fetchRequest)
        
        // check if there are dinnerItems in the coreDataStack
        guard let dinnerItemsCount = count,
            dinnerItemsCount == 0 else {
                return
        }
        // When there are no dinnerItems
        importCloudKitData(toUpdate: viewController)
        
    }
    private func importCloudKitData(toUpdate viewController: DinnerItemTableViewController) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DinnerItem", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = { record in
            let entityDescription = NSEntityDescription.entity(forEntityName: "DinnerItems", in: self.coreDataStack.managedContext)
            if let entityDescription = entityDescription {
                // create DinnerItems objects
                    let dinnerItem = DinnerItems(from: record, context: self.coreDataStack.managedContext, description: entityDescription)
                print(dinnerItem.name!)
                }
                
        }
        operation.queryCompletionBlock = { cursor, error in
            if let error = error {
                print ("error, \(error)")
            }
            self.coreDataStack.saveContext()
            // print to console how much in core data
            let fetchRequest: NSFetchRequest<DinnerItems> = DinnerItems.fetchRequest()
            let count = try? self.coreDataStack.managedContext.count(for: fetchRequest)
            print(" number of items loaded : \(String(describing: count))")
            // when the dinnerItems are saved to Core Data, perform a fetch on the main Queue and reload the data in the tableView
            DispatchQueue.main.async {
                do {
                    try viewController.fetchedResultsController.performFetch()
                    
                } catch let error as NSError {
                    print ("Fetching error: \(error), \(error.userInfo)")
                }
                viewController.tableView.reloadData()
            }
            
        }
        
        
        container.privateCloudDatabase.add(operation)
            }
    }


