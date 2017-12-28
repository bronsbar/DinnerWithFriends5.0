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
    
    var managedContext : NSManagedObjectContext!
    
    
    var dinnerItems: [DinnerItem] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DinnerItem", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = { record in
            let dinnerItem = DinnerItem(from: record)
            self.dinnerItems.append(dinnerItem)
        }
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.container.publicCloudDatabase.add(operation)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dinnerItems.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dinnerItemCell", for: indexPath) as! DinnerItemTableViewCell

        // Configure the cell...
        let index = indexPath.row
        
        cell.cellView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        cell.name.text = dinnerItems[index].name
        //update image
        if let imageAvailable = dinnerItems[index].image {
            cell.dinnerItemImage.image = imageAvailable
        } else {
            cell.imageContainerView.isHidden = true
            cell.imageSpinner.isHidden = true
        }
        
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
        if segue.identifier == "addItemDetailSegue" {
            // setup if new item added
            dinnerItemDetailVC?.newItem = true
        }
        if segue.identifier == "editDinnerItemSegue" {
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                dinnerItemDetailVC?.dinnerItemDetail = dinnerItems[selectedRow]
            } else {
                dinnerItemDetailVC?.dinnerItemDetail = nil
            }
            
        }
    }
    
    @IBAction func unwindFromDinnerItemDetail(segue:UIStoryboardSegue) {
        tableView.reloadData()
    }
}
