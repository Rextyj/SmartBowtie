//
//  UIViewExtension.swift
//  SmartBowtie
//
//  Created by Rex on 4/5/18.
//  Copyright © 2018 Rex Yijie Tong. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// The ratio (from 0.0 to 1.0, inclusive) of the view's corner radius
    /// to its width. For example, a 50% radius would be specified with
    /// `cornerRadiusRatio = 0.5`.
    @IBInspectable public var cornerRadiusRatio: CGFloat {
        get {
            return layer.cornerRadius / frame.width
        }
        
        set {
            // Make sure that it's between 0.0 and 1.0. If not, restrict it
            // to that range.
            let normalizedRatio = max(0.0, min(1.0, newValue))
            layer.cornerRadius = frame.width * normalizedRatio
        }
    }
}
