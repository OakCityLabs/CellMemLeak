//
//  UIView.swift
//  Callisto
//
//  Created by Sayam Patel on 10/11/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRounding: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
//
//    var isDarkMode: Bool {
//        traitCollection.userInterfaceStyle == .dark
//    }
    
    func addSubViewEdgeToEdge(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[subview]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["subview": subview]))
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
}
