//
//  DinnerItemTableViewController.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 20/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class DinnerItemTableViewController: UITableViewController {
    
    var coreDataStack  : CoreDataStack!
    
    // Create a fetchedResultsController to get the dinnerItems from Core Data
    lazy var fetchedResultsController: NSFetchedResultsController<DinnerItems> = {
        let fetchRequest: NSFetchRequest<DinnerItems> = DinnerItems.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DinnerItems.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    
    
    var dinnerItems: [DinnerItem] = []
    var coreDinnerItems: [DinnerItems] = []
    var itemSelected = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print ("Fetching error: \(error), \(error.userInfo)")
            }
            
        }
    
        // call extension in DinnerItems+CoreDataProperties to fetch the DinnerItems stored in CloudKit
//       fetchDinnerItemsFromCloudKit()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
   
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dinnerItemCell", for: indexPath) as! DinnerItemTableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? UINavigationController
        let dinnerItemDetailVC = destinationVC?.topViewController as? DinnerItemDetailViewController
        
        // propagate the managedContext
        dinnerItemDetailVC?.coreDataStack = coreDataStack
        
        if segue.identifier == "addDinnerItemSegue" {
            // setup if new item added
            dinnerItemDetailVC?.newItem = true
        }
        if segue.identifier == "editDinnerItemSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let dinnerItem = fetchedResultsController.object(at: selectedIndexPath)
                dinnerItemDetailVC?.dinnerItemDetail = dinnerItem
                
            } else {
                dinnerItemDetailVC?.dinnerItemDetail = nil
            }
            
        }
    }
    
    @IBAction func unwindFromDinnerItemDetail(segue:UIStoryboardSegue) {
        tableView.reloadData()
    }
}
// Extensions and helper functions

extension DinnerItemTableViewController {
    
    private func configureCell( cell: DinnerItemTableViewCell, for indexPath: IndexPath){
        
        let dinnerItem = fetchedResultsController.object(at: indexPath)
        
        cell.cellView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        cell.name.text = dinnerItem.name
        // Update the image
        if let image = dinnerItem.convertNSDataToUIImage(from: dinnerItem.image) {
            cell.dinnerItemImage.image = image
            cell.dinnerItemImage.layer.cornerRadius = (cell.dinnerItemImage.frame.height / 2)
        } else
        {
            cell.imageContainerView.isHidden = true
            cell.imageSpinner.isHidden = true
        }
    }
}

