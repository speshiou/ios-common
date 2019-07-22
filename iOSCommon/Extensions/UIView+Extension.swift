//
//  UIView+Extension.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/10/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func constrainToParent(insets: UIEdgeInsets = .zero) {
        guard let parent = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: parent.rightAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    
    // retrieves all constraints that mention the view
    func getAllConstraints() -> [NSLayoutConstraint] {
        
        // array will contain self and all superviews
        var views = [self]
        
        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }
        
        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }
    
    
    func changeCenterY(to value: CGFloat) {
        getAllConstraints().filter( {
            $0.firstAttribute == .centerY &&
                $0.firstItem as? UIView == self
        }).forEach({$0.constant = value})
    }
}
