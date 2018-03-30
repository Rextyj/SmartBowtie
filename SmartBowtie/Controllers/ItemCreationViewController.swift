//
//  ItemCreationViewController.swift
//  SmartBowtie
//
//  Created by Rex on 3/29/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit

class ItemCreationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var materialTextField: UITextField!
    @IBOutlet weak var patternTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "wallpaper-998234")
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
//        imageView.clipsToBounds = true
        
//        contentView.contentMode = UIViewContentMode.scaleAspectFill
//        contentView.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
//        imageView.frame.size.height = image.size.height
//        imageView.frame.size.width = image.size.width
//        self.view.layoutIfNeeded()
        imageView.image = image
        // Do any additional setup after loading the view.
    }

    @IBAction func onCancelPressed(_ sender: Any) {
    }
    

}
