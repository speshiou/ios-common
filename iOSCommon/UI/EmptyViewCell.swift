//
//  EmptyViewCell.swift
//  iOSCommon
//
//  Created by Pei-shiou Huang on 7/31/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

class EmptyViewCell: UITableViewCell {
    @IBOutlet weak var emptyView: EmptyView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
