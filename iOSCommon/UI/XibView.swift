//
//  XibView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/8/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

class XibView: UIView {
    
    lazy var className: String? = {
        let instanceInfo = String(describing: self)
        let regex = try? NSRegularExpression(pattern: "\\.([a-zA-Z]+)", options: [])
        let matches = regex?.matches(in: instanceInfo, options: [], range: NSRange(location: 0, length: instanceInfo.count))
        guard let groupRange = matches?[0].range(at: 1) else {
            return nil
        }
        return String(instanceInfo[Range(groupRange, in: instanceInfo)!])
    }()
    
    var nibName: String?
    
    init(nibName: String) {
        super.init(frame: CGRect.zero)
        self.nibName = nibName
        loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        guard let nibName = self.nibName ?? self.className else {
            return
        }
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
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
