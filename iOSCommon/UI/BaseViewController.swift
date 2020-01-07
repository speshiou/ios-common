//
//  BaseViewController.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/21/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func adjustViewFrameAsLongAsKeyboardState() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        if #available(iOS 11.0, *) {
            self.bottomConstraint?.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
            self.scrollView?.contentInset.bottom = keyboardFrame.height - self.view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        self.bottomConstraint?.constant = 0
        self.scrollView?.contentInset.bottom = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
