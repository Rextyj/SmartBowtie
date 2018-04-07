//
//  RandomItemViewController.swift
//  SmartBowtie
//
//  Created by Rex on 4/3/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit
import RealmSwift

class RandomItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{


    @IBOutlet weak var namePickerView: UIPickerView!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var materialPickerView: UIPickerView!
    @IBOutlet weak var patternPickerView: UIPickerView!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var patternLabel: UILabel!
    
    @IBOutlet weak var displayView: UIView!
    
    
    let realm = try! Realm()
    
    var itemContainter : Results<Bowtie>?
    
    //contains filtered items according to the searching scope
    var searchResult : Results<Bowtie>?
    var selectedItem = Bowtie()
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("images")
    //storing all attributes that has been entered
//    var attributesDict : [String : [String]] = ["name" : ["Any"], "color" : ["Any"], "material" : ["Any"], "pattern" : ["Any"]]
    
    var attributeContainer : Results<AttributeTitle>?
    
    let keyArray = ["name", "color", "material", "pattern"]
    
    var searchingScope : [String] = ["Any", "Any", "Any", "Any"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namePickerView.delegate = self
        namePickerView.dataSource = self
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        materialPickerView.delegate = self
        materialPickerView.dataSource = self
        patternPickerView.delegate = self
        patternPickerView.dataSource = self
        
        //add a tapgesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemTapped(gestureRecognizer:)))
        displayView.addGestureRecognizer(tapGestureRecognizer)
        
        loadUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        namePickerView.reloadAllComponents()
        colorPickerView.reloadAllComponents()
        materialPickerView.reloadAllComponents()
        patternPickerView.reloadAllComponents()
    }
    
    //MARK: - pickerviewcontroller de;egate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let container = attributeContainer else {fatalError()}
        if pickerView == namePickerView {
            //the number of rows is +1 because we need one extra row for displaying "any"
            return (container[2].attributes.count) + 1
        } else if pickerView == colorPickerView {
            return (container[0].attributes.count) + 1
        } else if pickerView == materialPickerView {
            return (container[1].attributes.count) + 1
        } else if pickerView == patternPickerView {
            return (container[3].attributes.count) + 1
        }
        return 1
    }
    
    //change the row text to corresponding value retrieved from the dictionary
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        //we need the first row to be displaying any!
        if row == 0 {
            return "Any"
        }
        
        if pickerView == namePickerView {
            //we can definetly find the key named name
            return (attributeContainer?[2].attributes[row - 1].name)!
        } else if pickerView == colorPickerView {
            return (attributeContainer?[0].attributes[row - 1].name)!
        } else if pickerView == materialPickerView {
            return (attributeContainer?[1].attributes[row - 1].name)!
        } else if pickerView == patternPickerView {
            return (attributeContainer?[3].attributes[row - 1].name)!
        }
        return "Any"
    }

    //after selecting a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == namePickerView {
            searchingScope[0] = self.pickerView(self.namePickerView, titleForRow: row, forComponent: component)!
        } else if pickerView == colorPickerView {
            searchingScope[1] = self.pickerView(self.colorPickerView, titleForRow: row, forComponent: component)!
        } else if pickerView == materialPickerView {
            searchingScope[2] = self.pickerView(self.materialPickerView, titleForRow: row, forComponent: component)!
        } else if pickerView == patternPickerView {
            searchingScope[3] = self.pickerView(self.patternPickerView, titleForRow: row, forComponent: component)!
        }
    }
    
    //MARK: - Tap gesture function
    
    @objc func itemTapped (gestureRecognizer : UITapGestureRecognizer) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destinationVC = segue.destination as! ItemDetailViewController
            
            destinationVC.selectedItem = selectedItem
        }
    }
    
    
    //MARK: - Button method
    @IBAction func buttonPressed(_ sender: UIButton) {
        loadUserData()
//        print("container size \(itemContainter?.count)")
        var predicate : NSPredicate?
        var count = 0
        var predicateArray = [NSPredicate]()
        for scopeName in searchingScope {
            if scopeName != "Any" {
                let currentPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", keyArray[count], scopeName)
                predicateArray.append(currentPredicate)
//                if let previousPredicate = predicate {
//                     predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [previousPredicate, currentPredicate])
//                } else {
//                    //if the predicate is nil the the currentPredicate is the first predicate
//                    predicate = currentPredicate
//                }
               
//                if predicateString.count != 0 {
//                    predicateString += " AND " + keyArray[count] + " CONTAINS[cd] " + scopeName
//                } else {
//                    predicateString += keyArray[count] + " CONTAINS[cd] " + scopeName
//                }
                
            }
            count += 1
        }
        print(predicateArray)
        predicate = NSCompoundPredicate(type: .and, subpredicates: predicateArray)
//        print(predicate!)
        //if the predicate is nil, then a random item is selected from the entire collection of items
        if predicate == nil {
            print("searching predicate is nil")
            searchResult = itemContainter
        } else {
            print("the predicate is \(String(describing: predicate))")
            //seachResult can be nil, which means no item matches the criteria
            searchResult = itemContainter?.filter(predicate!)
            print(searchResult?.count)
        }
        
        
        //if there is no item in the container
        if itemContainter?.count == 0 {
            print("There is not item in the container")
            
            let alert = UIAlertController(title: "No item saved", message: "Please at least add one item before doing this", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        //else
        guard let numberOfEle = searchResult?.count else {fatalError()}
        
        
        if numberOfEle != 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(numberOfEle)))
            print("randomIndex is \(randomIndex)")
            
            selectedItem = searchResult![randomIndex]
            print("searched item is \(String(describing: selectedItem))")
            
            //unhide the view
            displayView.isHidden = false
            nameLabel.text = selectedItem.name
            colorLabel.text = selectedItem.color
            materialLabel.text = selectedItem.material
            patternLabel.text = selectedItem.pattern
            itemImage.image = getImage(imageName: selectedItem.name)
            
        } else {
            print("No item matching specifying requirement")
            //remember UI changes needs to be completed in the main thread!!!
            DispatchQueue.main.async() {
               self.displayView.isHidden = true
            }
            
        }
        
        print(searchResult?.count)
        
    }
    
    //MARK: - Loading and saving data
    func loadUserData() {
        print("loaddata is called")

        //sorting is very important! Otherwise, deleting will mess up the order of the data in the container!
        itemContainter = realm.objects(Bowtie.self).sorted(byKeyPath: "name", ascending: true)
        attributeContainer = realm.objects(AttributeTitle.self).sorted(byKeyPath: "name", ascending: true)

    }
    
    func getImage(imageName : String) -> UIImage? {
        let imagePath = path?.appendingPathComponent(imageName + ".png")
        
        do {
            _  = try imagePath?.checkResourceIsReachable()
            return UIImage(contentsOfFile: (imagePath?.path)!)
        } catch {
            print("error reaching url")
            return UIImage(named: "broken-image")
        }
    }
    
    
}


