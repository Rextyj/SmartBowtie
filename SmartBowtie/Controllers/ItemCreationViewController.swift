//
//  ItemCreationViewController.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var materialTextField: UITextField!
    @IBOutlet weak var patternTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveButtonView: UIView!
    
    let realm = try! Realm()
    var imagePickerController : UIImagePickerController!
    
    var itemToEdit : Bowtie?
    var attributesContainer : Results<AttributeTitle>?
     let keyArray = ["name", "color", "material", "pattern"]
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("images")
    
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
        
        //set up tag gesture recognizer for the image view
        let tapGestureRecognizerOnImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizerOnImage)
        
        //set up keyboard dismissal gesture recognizer
        let keyboardDismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardDismissGestureRecognizer)
        
        //change button's background color
        saveButtonView.backgroundColor = FlatSkyBlue()
        
        if itemToEdit != nil {
            displaySavedData()
        }
        loadAttributeDict()
    }

    @objc func imageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo libaray", style: .default, handler: { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - image picker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//    }
    
//    @IBAction func onCancelPressed(_ sender: Any) {
//        //don't perform a segue
//        self.dismiss(animated: true, completion: nil)
//    }
    
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
//        newBowtie.filePath = path.appendingPathComponent(nameTextField.text! + ".png")
        
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
            
            updateAttributes(newBowtie)
            let isSaved = save(bowtie: newBowtie)
            
            if isSaved {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func save(bowtie : Bowtie) -> Bool{
        do {
            print("Saving now")
            try saveImage(imageName: bowtie.name)
            try realm.write {
                realm.add(bowtie, update: true)
//                realm.add(attributesContainer!, update: true)
            }
        } catch {
            print("Error saving data, \(error)")
            return false
        }
        return true
    }
    
    func saveImage(imageName : String) throws {
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: path!, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("folder already existed, \(error)")
        }
        
        
        let imagePath = path?.appendingPathComponent(imageName + ".png")
        print("the image path is " + (imagePath?.absoluteString)!)
        
        let image = imageView.image!
        
        //get the PNG data for this image
        
        //Note we have to use JPEG representation here because PNG does not store orientation info
        let data = UIImageJPEGRepresentation(image, 0.4)
        //store it in the document directory    fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        do{
            try data?.write(to: imagePath!)
        } catch {
            print("error saving image")
        }
        
    }
    
    func loadAttributeDict() {
        attributesContainer = realm.objects(AttributeTitle.self)
    }
    
    
    func getImage(imageName : String) -> UIImage? {
        //get image called
//        let fileManager = FileManager.default
        
        //        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName + ".png")
        let imagePath = path?.appendingPathComponent(imageName + ".png")
        
        //        let imagePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName)
        
        
        do {
            _  = try imagePath?.checkResourceIsReachable()
            return UIImage(contentsOfFile: (imagePath?.path)!)
        } catch {
            print("error reaching url")
            return UIImage(named: "broken-image")
        }
        
    }
    
    func updateAttributes(_ newBowtie: Bowtie) {
       
        
        for keyName in keyArray {
            do {
                try realm.write {
                    let newAttribute = AttributeName()
                    newAttribute.name = newBowtie.value(forKey: keyName) as! String
                    print("creating new attribute \(keyName) with value \(newAttribute.name)")
                    guard let attributes = attributesContainer?.filter("name CONTAINS[cd] %@", keyName).first?.attributes else {fatalError("error loading attrbutes")}
                    
                    let stored = attributes.filter("name ==[cd] %@", newAttribute.name)
                    
                    if stored.count != 0{
                        print("attribute already exist")
                        //increase count by one if it already exists
                        stored.first?.count += 1
                    } else {
                        attributes.append(newAttribute)
                    }
                }
            } catch {
                print("error writing to realm")
            }
            
            
        }
//        attributesContainer?.filter("name == %@", )
//        dictRef["name"]?.append(newBowtie.name)
//        dictRef["color"]?.append(newBowtie.color)
//        dictRef["material"]?.append(newBowtie.material)
//        dictRef["pattern"]?.append(newBowtie.pattern)
    }
}

