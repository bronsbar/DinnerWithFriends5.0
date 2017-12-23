//
//  DinnerItemDetailViewController.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 21/12/17.
//  Copyright © 2017 Bart Bronselaer. All rights reserved.
//

import UIKit
import SafariServices
import CoreGraphics

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
    
    
    
    
    
    @IBOutlet weak var urlLabel: UITextField! {
        didSet {
            urlLabel.layer.cornerRadius = urlLabel.bounds.height / 2
        }
    }
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ratingLabel: UITextField! {
        didSet {
            ratingLabel.layer.cornerRadius = ratingLabel.bounds.height / 2
        }
    }
    
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func urlLabelTapped(_ sender: UITextField) {
        // select een url via SafariController
        selectUrl()
    }
    @IBAction func textEditingChanged(_ sender: UITextField) {
        // Save button is only active when the name field is filled out
        updateSaveButtonStatus()
    }
    @IBAction func picturedTapped(_ sender: UITapGestureRecognizer) {
        print("picture tapped")
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonStatus()
        
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

extension DinnerItemDetailViewController :SFSafariViewControllerDelegate{
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
    private func updateSaveButtonStatus()-> Void {
    let nameText = nameLabel.text ?? ""
        saveButton.isEnabled = !((nameText == "Name")||(nameText.isEmpty))
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        urlLabel.text = URL.absoluteString
        dinnerItemDetail?.url = URL
        let a :[UIActivity] = []
        return a
    }
    private func selectUrl () {
        if let url = dinnerItemDetail?.url {
            let safariController = SFSafariViewController(url: url)
            safariController.delegate = self
            present(safariController, animated: true, completion: nil)
        } else {
            let defaultUrlString = "https:www.google.com"
            if let defaultUrl = URL(string:defaultUrlString){
                let safariController = SFSafariViewController(url: defaultUrl)
                safariController.delegate = self
                present(safariController, animated: true, completion: nil)
            }
        }
    }
}
