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
    
    public var data: EmptyViewData? {
        didSet {
            guard let data = self.data else {
                return
            }
            self.iconImageView.isHidden = data.icon == nil
            self.iconImageView.image = data.icon
            self.infoLabel.text = data.message
            self.actionButton.isHidden = data.actionButtonText == nil
            self.actionButton.setTitle(data.actionButtonText, for: .normal)
            self.actionButtonClickDelegate = data.actionButtonDidClick
        }
    }
    
    @IBAction func didClickActionButton(_ sender: Any) {
        self.actionButtonClickDelegate?()
    }
}
