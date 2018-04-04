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
}
