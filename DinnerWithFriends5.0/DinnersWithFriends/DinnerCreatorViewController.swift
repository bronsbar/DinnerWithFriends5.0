//
//  DinnerCreatorViewController.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 9/01/18.
//  Copyright © 2018 Bart Bronselaer. All rights reserved.
//

import UIKit
import CoreData

class DinnerCreatorViewController: UIViewController{
    @IBOutlet weak var dinnerItemsCollectionView: UICollectionView!
    
    var coreDataStack : CoreDataStack!
    
    lazy var fetchedResultsController: NSFetchedResultsController<DinnerItems> = {
        let fetchRequest: NSFetchRequest<DinnerItems> = DinnerItems.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DinnerItems.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dinnerItemsCollectionView.delegate = self
        dinnerItemsCollectionView.dataSource = self
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print ("Fetching error: \(error), \(error.userInfo)")
        }
    }

 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: -NSFetchedResultsControllerDelegate

extension DinnerCreatorViewController: NSFetchedResultsControllerDelegate {
    
}

// MARK: -UICollectionView datasource and delegate
extension DinnerCreatorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let numberOfObjects = fetchedResultsController.fetchedObjects?.count {
            return numberOfObjects
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dinnerItemsCollectionViewCell", for: indexPath) as! DinnerItemCollectionViewCell
            configureCell(cell: cell, at: indexPath)
        return cell
       
    }
    func configureCell(cell:DinnerItemCollectionViewCell, at indexPath: IndexPath) {
        let dinnerItem = fetchedResultsController.object(at: indexPath)
        
        cell.label.text = dinnerItem.name
        if let image = dinnerItem.convertNSDataToUIImage(from: dinnerItem.image) {
            cell.image.image = image
        }
        
    }
    
    
}
