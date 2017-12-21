//
//  DinnerItemDetailViewController.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 21/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import UIKit

class DinnerItemDetailViewController: UIViewController {
    
    var newItem : Bool = false // is set true by when + is selected in the dinnerItemList
    var dinnerItemDetail : DinnerItem? // will be set when a dinnerItem is passed from the dinnerItem list

    @IBOutlet weak var notesContainer: UIView! {
        didSet {
            notesContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            notesContainer.layer.borderWidth = 0.5
            notesContainer.layer.cornerRadius = notesContainer.bounds.height * 0.1
            
        }
    }
    @IBOutlet weak var imageContainer: UIView! {
        didSet {
            imageContainer.clipsToBounds = true
            imageContainer.layer.cornerRadius = imageContainer.bounds.height * 0.1
        }
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ratingLabel: UITextField!
    @IBOutlet weak var notesLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if a dinnerItem has been sent by the list, set the fields
        if let receivedDinnerItem = dinnerItemDetail {
            updateFields(with: receivedDinnerItem)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DinnerItemDetailViewController {
    // MARK: HelperFunctions
    
    private func updateFields(with dinnerItem : DinnerItem) {
        
        if let imageAvailable = dinnerItem.image {
            image.image = imageAvailable
        }
        nameLabel.text = dinnerItem.name
        if let urlAvailable = dinnerItem.url {
            urlLabel.text = String(describing: urlAvailable)
        }
        if let ratingAvailable = dinnerItem.rating {
            ratingLabel.text = String(ratingAvailable)
        }
        if let notesAvailable = dinnerItem.notes {
            notesLabel.text = notesAvailable
        }
    }
}
