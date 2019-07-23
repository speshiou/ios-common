//
//  EmptyView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/8/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

class EmptyView: XibView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var actionButtonClickDelegate: (() -> Void)?
    
    @IBAction func didClickActionButton(_ sender: Any) {
        self.actionButtonClickDelegate?()
    }
}
