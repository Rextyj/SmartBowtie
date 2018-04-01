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
    
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
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
        //get image called
        let fileManager = FileManager.default
        
        let imagePath = path.appendingPathComponent(imageName + ".png")
        print(imagePath)
        
//        let imagePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("Error loading image")
            return UIImage(named: "broken-image")
        }
        
    }
    
    func loadData() {
        if let currentItem = selectedItem {
            print("this item has name" + currentItem.name)
            imageView.image = getImage(imageName: currentItem.name)
        }
    }
    
}
