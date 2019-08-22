//
//  UIViewExtension.swift
//  kkhw
//
//  Created by wonwoolee on 2019/08/17.
//  Copyright © 2019 wonwoolee. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    /**
     Autolayout Visual Layout으로 Constraints 추가하기 위한 Wrapper API
     
     - Parameters:
     - format: visual format. visual format내 view는 v0,v1,v2..로 지칭한다.
     - views: visual format내 v0, v1, v2, ..과 매치되는 view
     */
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addSubviewWithSameSize(_ v:UIView){
        addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: v)
        addConstraintsWithFormat(format: "V:|-0-[v0]-0-|", views: v)
    }
}
