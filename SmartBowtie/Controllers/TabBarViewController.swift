//
//  TabBarViewController.swift
//  SmartBowtie
//
//  Created by Rex on 4/8/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    let scrollDelegate = ScrollingTabBarControllerDelegate() as UITabBarControllerDelegate
    
    override func viewDidLoad() {
        print("tab bar loaded")
        super.viewDidLoad()
        self.delegate = scrollDelegate
    }

}
