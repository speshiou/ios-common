//
//  EmptyViewCell.swift
//  iOSCommon
//
//  Created by Pei-shiou Huang on 7/31/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class EmptyViewCell: UITableViewCell {
    @IBOutlet public weak var emptyView: EmptyView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
