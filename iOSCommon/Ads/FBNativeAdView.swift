//
//  FBNativeAdBannerView.swift
//  bbmap
//
//  Created by Pei-shiou Huang on 12/4/18.
//  Copyright © 2018 YUHO. All rights reserved.
//

import UIKit
import FBAudienceNetwork

class FBNativeAdView: XibView {
    
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var iconView: FBMediaView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var adOptionsView: FBAdOptionsView!
    @IBOutlet weak var mediaView: FBMediaView!
    
    var fbNativeAd: FBNativeAdBase? {
        didSet {
            
        }
    }
    
    override func loadViewFromNib() {
        super.loadViewFromNib()
//        actionButton.layer.borderColor = Colors.accent.cgColor
    }
}
