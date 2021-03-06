//
//  Bowtie.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import Foundation
import RealmSwift

class Bowtie : Object {
    @objc dynamic var name : String = "Not Set"
    @objc dynamic var color : String = "Not Set"
    @objc dynamic var material : String = "Not Set"
    @objc dynamic var pattern : String = "Not Set"
    @objc dynamic var comments : String = "Empty"
    
    @objc dynamic var dateAdded : Date = Date()
    
    @objc dynamic var itemID = UUID().uuidString
    
    //need to get a new path everytime
//    @objc dynamic var filePath : String?
    
    override static func primaryKey() -> String? {
        return "itemID"
    }
    
//    @objc dynamic var thumbnailName : String =
}
