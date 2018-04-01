//
//  ItemCreationViewController.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit
import RealmSwift

class ItemCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var materialTextField: UITextField!
    @IBOutlet weak var patternTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    let realm = try! Realm()
    var imagePickerController : UIImagePickerController!
    
    var itemToEdit : Bowtie?
    
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
    
    enum savingError : Error {
        case errorSavingImageToPath
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "image-placeholder")
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
//        imageView.clipsToBounds = true
        
//        contentView.contentMode = UIViewContentMode.scaleAspectFill
//        contentView.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
//        imageView.frame.size.height = image.size.height
//        imageView.frame.size.width = image.size.width
//        self.view.layoutIfNeeded()
        imageView.image = image
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizerOnImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizerOnImage)
        
        let keyboardDismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardDismissGestureRecognizer)
        
        if itemToEdit != nil {
            displaySavedData()
        }
    }

    @objc func imageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func onCancelPressed(_ sender: Any) {
        //don't perform a segue
        self.dismiss(animated: true, completion: nil)
    }
    
    func displaySavedData() {
        imageView.image = getImage(imageName: itemToEdit!.name)
        nameTextField.text = itemToEdit?.name
        colorTextField.text = itemToEdit?.color
        materialTextField.text = itemToEdit?.material
        patternTextField.text = itemToEdit?.pattern
        commentsTextField.text = itemToEdit?.comments
        
    }
    
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let newBowtie = Bowtie()
        
        //it will be an empty string if nothing is inputed
        newBowtie.name = nameTextField.text!
        newBowtie.color = colorTextField.text!
        newBowtie.material = materialTextField.text!
        newBowtie.pattern = patternTextField.text!
        newBowtie.comments = commentsTextField.text!
        newBowtie.filePath = path.appendingPathComponent(nameTextField.text! + ".png")
        
        if let existingID = itemToEdit?.itemID {
            newBowtie.itemID = existingID
        }
        
        
        if newBowtie.name.count == 0 {
            print("name filed is not filled")
            let alert = UIAlertController(title: "Missing Information", message: "Please enter the name of the bowtie", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Close", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let isSaved = save(bowtie: newBowtie)
            if isSaved {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func save(bowtie : Bowtie) -> Bool{
        do {
            print("Saving now")
            try saveImage(imageName: bowtie.name)
            try realm.write {
                realm.add(bowtie, update: true)
            }
        } catch {
            print("Error saving data, \(error)")
            return false
        }
        return true
    }
    
    func saveImage(imageName : String) throws {
        let fileManager = FileManager.default
        
        let imagePath = path.appendingPathComponent(imageName + ".png")
        print("the image path is " + imagePath)
        
        let image = imageView.image!
        
        //get the PNG data for this image
        
        //Note we have to use JPEG representation here because PNG does not store orientation info
        let data = UIImageJPEGRepresentation(image, 0.4)
        //store it in the document directory    fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        let isSaved = fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
        if isSaved != true {
            throw savingError.errorSavingImageToPath
        }
    }
    
    func getImage(imageName : String) -> UIImage? {
        //get image called
        let fileManager = FileManager.default
        
        //        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName + ".png")
        let imagePath = itemToEdit!.filePath!
        
        //        let imagePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("Error loading image")
            return UIImage(named: "broken-image")
        }
        
    }
}
