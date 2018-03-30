//
//  CustomTableViewCell.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var bowtieThumbnail: UIImageView!
    @IBOutlet weak var bowtieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bowtieThumbnail.image = UIImage(named: "bowtie-placeholder")
    }

}
