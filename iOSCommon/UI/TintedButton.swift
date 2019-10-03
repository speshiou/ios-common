//
//  TintedButton.swift
//  CropViewController
//
//  Created by Pei-shiou Huang on 10/3/19.
//

import UIKit

open class TintedButton: UIButton {
    
    private var normalColor: UIColor? = nil
    private var pressColor: UIColor? = nil

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.normalColor = self.backgroundColor
        self.pressColor = self.backgroundColor?.withAlphaComponent(0.8)
    }

    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? pressColor : normalColor
        }
    }
}
