//
//  AttributeNames.swift
//  SmartBowtie
//
//  Created by Rex on 4/3/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import Foundation
import RealmSwift

class AttributeTitle : Object{
    @objc dynamic var name : String = ""
    
    let attributes = List<AttributeName>()
    
    func deleteAttributes(attribute name: String) {
        let realm = try! Realm()
        //only one of the below objects exist
        let attributeToDelete = attributes.filter("name ==[cd] %@", name).first!
        
            do {
                try realm.write {
                    if attributeToDelete.count == 1 {
                        realm.delete(attributeToDelete)
                    } else {
                        attributeToDelete.count -= 1
                    }
                    
                }
            } catch {
                print("error writing to realm")
            }
        
    }
}
