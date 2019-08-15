//
//  XibView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/8/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class XibView: UIView {
    
    var className: String!
    var bundle: Bundle!
    
    var nibName: String?
    
    public init(nibName: String) {
        super.init(frame: CGRect.zero)
        self.nibName = nibName
        loadViewFromNib()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    private func parseBundleInfo() {
        let instanceInfo = String(describing: self)
        let regex = try? NSRegularExpression(pattern: "([a-zA-Z]+)\\.([a-zA-Z]+)", options: [])
        let matches = regex?.matches(in: instanceInfo, options: [], range: NSRange(location: 0, length: instanceInfo.count))
        guard let bundleNameRange = matches?[0].range(at: 1) else {
            return
        }
        guard let classNameRange = matches?[0].range(at: 2) else {
            return
        }
        self.bundle = String(instanceInfo[Range(bundleNameRange, in: instanceInfo)!]) == PodHelper.podName ? PodHelper.bundle : Bundle.main
        self.className = String(instanceInfo[Range(classNameRange, in: instanceInfo)!])
    }
    
    func loadViewFromNib() {
        if self.nibName == nil {
            self.parseBundleInfo()
        } else {
            self.bundle = Bundle.main
        }
        guard let nibName = self.nibName ?? self.className else {
            return
        }
        if let view = self.bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            addSubview(view)
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        }
    }
}
