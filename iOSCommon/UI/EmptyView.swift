//
//  EmptyView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/8/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class EmptyView: XibView {

    @IBOutlet public weak var iconImageView: UIImageView!
    @IBOutlet public weak var infoLabel: UILabel!
    @IBOutlet public weak var actionButton: UIButton!
    
    public var actionButtonClickDelegate: (() -> Void)?
    
    @IBAction func didClickActionButton(_ sender: Any) {
        self.actionButtonClickDelegate?()
    }
}
