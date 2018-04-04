//
//  RandomItemViewController.swift
//  SmartBowtie
//
//  Created by Rex on 4/3/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit
import RealmSwift

class RandomItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var namePickerView: UIPickerView!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var materialPickerView: UIPickerView!
    @IBOutlet weak var patternPickerView: UIPickerView!
    
    let realm = try! Realm()
    
    var itemContainter : Results<Bowtie>?
    
    //contains filtered items according to the searching scope
    var searchResult : Results<Bowtie>?
    
    //storing all attributes that has been entered
    var attributesDict : [String : [String]] = ["name" : ["Any"], "color" : ["Any"], "material" : ["Any"], "pattern" : ["Any"]]
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
        
        loadUserData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - pickerviewcontroller de;egate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == namePickerView {
            //we can definetly find the key named name
            return (attributesDict["name"]?.count)!
        } else if pickerView == colorPickerView {
            return (attributesDict["color"]?.count)!
        } else if pickerView == materialPickerView {
            return (attributesDict["material"]?.count)!
        } else if pickerView == patternPickerView {
            return (attributesDict["pattern"]?.count)!
        }
        return 1
    }
    
    //change the row text to corresponding value retrieved from the dictionary
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == namePickerView {
            //we can definetly find the key named name
            return (attributesDict["name"]?[row])!
        } else if pickerView == colorPickerView {
            return (attributesDict["color"]?[row])!
        } else if pickerView == materialPickerView {
            return (attributesDict["material"]?[row])!
        } else if pickerView == patternPickerView {
            return (attributesDict["pattern"]?[row])!
        }
        return "Any"
    }

    //after selecting a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchingScope[component] = self.pickerView(self.namePickerView, titleForRow: row, forComponent: component)!
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        var predicate : NSPredicate?
        var count = 0
        for scopeName in searchingScope {
            if scopeName != "Any" {
                let currentPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", keyArray[count], scopeName)
                if let previousPredicate = predicate {
                     predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [previousPredicate, currentPredicate])
                } else {
                    predicate = currentPredicate
                }
               
//                if predicateString.count != 0 {
//                    predicateString += " AND " + keyArray[count] + " CONTAINS[cd] " + scopeName
//                } else {
//                    predicateString += keyArray[count] + " CONTAINS[cd] " + scopeName
//                }
                
            }
            count += 1
        }
//        print(predicate!)
        //if the predicate is nil, then a random item is selected from the entire collection of items
        if predicate == nil {
            print("searching predicate is nil")
            searchResult = itemContainter
        } else {
            //seachResult can be nil, which means no item matches the criteria
            searchResult = itemContainter?.filter(predicate!)
        }
        
        if let numberOfEle = searchResult?.count {
            //if there is no item in the container
            if numberOfEle == 0 {
                print("There is not item in the container")
                
                let alert = UIAlertController(title: "No item saved", message: "Please at least add one item before doing this", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                present(alert, animated: true, completion: nil)
                return
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(numberOfEle)))

            //
            let selectedItem = itemContainter![randomIndex]
        } else {
            print("No item matching specifying requirement")
        }
        
        
        print(searchResult?.count)
        
    }
    
    //MARK: - Loading and saving data
    func loadUserData() {
        print("loaddata is called")

        //sorting is very important! Otherwise, deleting will mess up the order of the data in the container!
        itemContainter = realm.objects(Bowtie.self).sorted(byKeyPath: "name", ascending: true)

    }
    
}
