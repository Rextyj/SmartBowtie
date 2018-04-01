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
    //auto-updating
    var bowtieContainer : Results<Bowtie>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        print("view did load ")
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["Name", "Color", "Material", "Pattern"]
        
        tableView.delegate = self
        loadUserData()
        
//        tableView.rowHeight =
        //TODO: Register custom cell file
//        tableView.register(UINib(nibName: "CustomTableViewCell", bundle : nil), forCellReuseIdentifier: "CustomBowtieCell")
    }
    
    //refresh tableview after dismissing another view
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bowtieContainer?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellforrow called")
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

        if let currentBowtie = bowtieContainer?[indexPath.row] {
//            print("changing name from \(cell.bowtieName.text) to \(currentBowtie.name)")
            cell.bowtieName.text = currentBowtie.name
//            cell.bowtieThumbnail.image = currentBowtie.
        } else {
            cell.bowtieName.text = "Please add a new bowtie"
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let currentBowtie = self.bowtieContainer?[indexPath.row] {
            do {
                try self.realm.write {
//                    print("attempt to delete at row \(indexPath.row) the name is \(currentBowtie.name)")
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
        performSegue(withIdentifier: "goToItemDetail", sender: self)
    }
    
    //pass in the info about selected bowtie
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemDetail" {
            
            let destinationVC = segue.destination as! ItemDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedItem = bowtieContainer?[indexPath.row]
            }
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
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
        print("loaddata is called")
        
        //sorting is very important! Otherwise, deleting will mess up the order of the data in the container!
        bowtieContainer = realm.objects(Bowtie.self).sorted(byKeyPath: "name", ascending: true)
        
//        if bowtieContainer != nil {
//            print("not nil")
//            bowtieContainer = bowtieContainer?.sorted(byKeyPath: "dateAdded", ascending: true)
//        }
        
        tableView.reloadData()
    }
    
}
    extension CollectionViewController : UISearchBarDelegate {
    
    //MARK: - search bar delegate methods
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let scopeIndex = searchBar.selectedScopeButtonIndex
        let searchScope = searchBar.scopeButtonTitles![scopeIndex].lowercased()
//            switch scopeIndex {
//            case 0 :
//                bowtieContainer =  bowtieContainer?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
//            case 1:
//                bowtieContainer =  bowtieContainer?.filter("color CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
//            case 2:
//                bowtieContainer =  bowtieContainer?.filter("material CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
//            case 3:
//                bowtieContainer =  bowtieContainer?.filter("pattern CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
//            default:
//                print("error")
//            }
        
        //key in the predicate is specified with %k not %@
        bowtieContainer =  bowtieContainer?.filter("%K CONTAINS[cd] %@", searchScope, searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            
//        bowtieContainer =  bowtieContainer?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
//        bowtieContainer =  bowtieContainer?.filter(predicate)
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("textdidbeginediting")
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        view.endEditing(true)
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print(searchBar.scopeButtonTitles![selectedScope])
////        let predicate = NSPredicate(format: "%@ CONTAINS[cd] %@", searchBar.scopeButtonTitles![selectedScope].lowercased(), searchBar.text!)
////        searchBarSearchButtonClicked(searchBar, predicate: predicate)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadUserData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


