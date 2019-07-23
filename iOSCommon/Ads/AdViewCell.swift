//
//  AdViewCell.swift
//  bbmap
//
//  Created by speshiou on 2017/9/25.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import UIKit

public class AdViewCell: UITableViewCell {

    @IBOutlet weak var wrapper: UIView!
    
    var adTask: LoadAdTask?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        let wrapper = self.wrapper ?? self.contentView
        for subview in wrapper.subviews {
            subview.removeFromSuperview()
        }
    }
}
