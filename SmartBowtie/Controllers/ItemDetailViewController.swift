//
//  ItemDetailViewController.swift
//  SmartBowtie
//
//  Created by Rex on 3/31/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var colorField: UILabel!
    @IBOutlet weak var materialField: UILabel!
    @IBOutlet weak var patternField: UILabel!
    @IBOutlet weak var commentField: UITextView!
    
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("images")
    var selectedItem : Bowtie? {
        didSet {
            print("item passed")
            
            //can't call load data here, the viewdidload method is not called yet and the imageview is still nil!!!!
//            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        getImage(imageName: (selectedItem?.name)!)
        loadData()
    }

    //reload contents after editing
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToItemEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemEdit" {
            let destinationVC = segue.destination as! ItemCreationViewController
            
            if let itemToPass = selectedItem {
                destinationVC.itemToEdit = itemToPass
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getImage(imageName : String) -> UIImage? {
        
        let imagePath = path?.appendingPathComponent(imageName + ".png")
        print(imagePath?.absoluteString)
        
//        let imagePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName)
        do {
            _  = try imagePath?.checkResourceIsReachable()
            return UIImage(contentsOfFile: (imagePath?.path)!)
        } catch {
            print("error reaching url")
            return UIImage(named: "broken-image")
        }
        
        
    }
    
    func loadData() {
        if let currentItem = selectedItem {
            print("this item has name" + currentItem.name)
            imageView.image = getImage(imageName: currentItem.name)
            
            nameField.text = currentItem.name
            colorField.text = currentItem.color
            materialField.text = currentItem.material
            patternField.text = currentItem.pattern
            commentField.text = currentItem.comments
        }
    }
    
}
