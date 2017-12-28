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
import CoreData

class DinnerItemDetailViewController: UIViewController {
    
    var newItem : Bool = false // is set true by when + is selected in the dinnerItemList
    var dinnerItemDetail : DinnerItem? // will be set when a dinnerItem is passed from the dinnerItem list
    
    var managedContext : NSManagedObjectContext!

    @IBOutlet weak var notesContainer: UIView! {
        didSet {
            notesContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            notesContainer.layer.borderWidth = 0.5
            notesContainer.layer.cornerRadius = notesContainer.bounds.height * 0.1
            
        }
    }
    @IBOutlet weak var imageContainer: UIView! {
        didSet {
            
            let shadowPath = UIBezierPath(rect: imageContainer.bounds)
            imageContainer.layer.masksToBounds = false
            imageContainer.layer.shadowOpacity = 0.5
            
            imageContainer.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            imageContainer.layer.shadowRadius = 5
            imageContainer.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            imageContainer.layer.shadowPath = shadowPath.cgPath
    
            
        }
    }
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var urlLabel: UITextField! {
        didSet {
            urlLabel.layer.cornerRadius = urlLabel.bounds.height * 0.1
        }
    }
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ratingLabel: UITextField! {
        didSet {
            ratingLabel.layer.cornerRadius = ratingLabel.bounds.height * 0.1
        }
    }
    
    @IBOutlet weak var notesLabel: UITextView! {
        didSet {
            notesLabel.layer.cornerRadius = notesLabel.bounds.height * 0.10
        }
    }
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
        updateImage()
    }
  
    // MARK: Pan the Image
    // helpermethod transform calculates the transform
    private func transform(for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -sin(translation.x / (imageContainer.frame.width * 4.0))
        return moveBy.rotated(by: rotation)
    }
    
    @IBAction func panImage(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: imageContainer.superview)
            imageContainer.transform = transform(for: translation)
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [], animations : {self.imageContainer.transform = .identity}, completion: nil)
            
        default:
            break
        }
        
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

extension DinnerItemDetailViewController :SFSafariViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    private func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photolibrary", style: .default, handler: { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    private func addDinnerItem() {
        let dinnerItem = DinnerItems(context: managedContext)
        dinnerItem.added = NSDate()
        dinnerItem.lastUpdate = NSDate()
        let name = nameLabel.text ?? nil
        dinnerItem.name = name
        let notes = notesLabel.text ?? nil
        dinnerItem.notes = notes
        // add additional elements
    }
}
