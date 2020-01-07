//
//  AlertController.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/8/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class AlertController: UIAlertController {

    var target: Any? {
        didSet {
            if let view = self.target as? UIView {
                if let popover: UIPopoverPresentationController = self.popoverPresentationController {
                    popover.sourceView = view
                    popover.sourceRect = view.bounds
                }
            } else if let item = self.target as? UIBarButtonItem {
                if let popover: UIPopoverPresentationController = self.popoverPresentationController {
                    popover.barButtonItem = item
                }
            }
        }
    }
    
    var attributedMessage: NSAttributedString? {
        didSet {
            self.setValue(self.attributedMessage, forKey: "attributedMessage")
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func addYesAction(handler: ((UIAlertAction) -> Void)?) {
        self.addAction(UIAlertAction(title: i18n.yes, style: .default, handler: handler))
    }
    
    open func addCancelAction(handler: ((UIAlertAction) -> Void)? = nil) {
        self.addAction(UIAlertAction(title: i18n.cancel, style: .cancel, handler: handler))
    }
    
    open func addCloseAction(handler: ((UIAlertAction) -> Void)? = nil) {
        self.addAction(UIAlertAction(title: i18n.close, style: .cancel, handler: handler))
    }

}
