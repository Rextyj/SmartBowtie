//
//  CollectionViewController.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import Foundation
import RealmSwift

class CollectionViewController : SwipeTableViewController {
    var bowtieContainer : Results<Bowtie>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        loadUserData()
//        tableView.rowHeight =
        //TODO: Register custom cell file
//        tableView.register(UINib(nibName: "CustomTableViewCell", bundle : nil), forCellReuseIdentifier: "CustomBowtieCell")
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bowtieContainer?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellforrow called")
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

        if let currentBowtie = bowtieContainer?[indexPath.row] {
            print("changing name")
            cell.bowtieName.text = currentBowtie.name
        } else {
            print("no item")
            cell.bowtieName.text = "Please add a new bowtie"
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let currentBowtie = self.bowtieContainer?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(currentBowtie)
                }
            } catch {
                print("error deleteing")
            }
            //if we don't use options for row at, we need to reload the data
//           tableView.reloadData()
        }
    }
    
    //MARK: -  table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItemCreation", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ItemCreationViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destinationVC = indexPath
//        }
//    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
//        let alert = UIAlertController(title: "Add A New Bowtiew", message: "", preferredStyle: .alert)
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "New Bowtie Name"
//        }
//
//        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//
//            if let bowtieName = alert.textFields![0].text {
//                //create a new category object
//                let newBowtie = Bowtie()
//                newBowtie.name = bowtieName
//
//                //                self.categoryArray.append(newCategory)
//                self.save(bowtie: newBowtie)
//            }
//
//            self.tableView.reloadData()
//        }
//
//        alert.addAction(action)
//        //this shows the alert over the current view
//        present(alert, animated: true, completion: nil)
         performSegue(withIdentifier: "goToItemCreation", sender: self)
    }
    
    //MARK: - Data manipulation
    func save(bowtie : Bowtie) {
        do {
            print("Saving now")
            try realm.write {
                realm.add(bowtie)
            }
        } catch {
            print("Error saving data")
        }
    }
    
    func loadUserData() {
        bowtieContainer = realm.objects(Bowtie.self)
        
        tableView.reloadData()
    }
}



