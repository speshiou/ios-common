//
//  AdmobNativeAdView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/13/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit
import FirebaseCore
import GoogleMobileAds

class AdmobNativeAdView: UIView {
    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView!
    @IBOutlet weak var mediaView: GADMediaView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingBar: UIStackView!
    @IBOutlet weak var secondaryLineSection: UIStackView!
    @IBOutlet weak var adChoicesView: GADAdChoicesView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var mediaHeight: NSLayoutConstraint!
    
    var nibName = ""
    
    init(nibName: String) {
        super.init(frame: CGRect.zero)
        self.nibName = nibName
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        if let view = Bundle.main.loadNibNamed(self.nibName, owner: self, options: nil)?.first as? UIView {
            self.nativeAdView.adChoicesView = self.adChoicesView
            self.nativeAdView.advertiserView = self.adLabel
            self.nativeAdView.callToActionView = self.actionButton
            self.nativeAdView.headlineView = self.titleLabel
            self.nativeAdView.bodyView = self.bodyLabel
            self.nativeAdView.iconView = self.iconImageView
            self.nativeAdView.mediaView = self.mediaView
            self.nativeAdView.starRatingView = self.ratingBar
            self.nativeAdView.priceView = self.subtitleLabel
            self.nativeAdView.storeView = self.captionLabel
            view.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
//            actionButton.layer.borderColor = Colors.accent.cgColor
            addSubview(view)
            view.constrainToParent()
//            if let wrapper = createAdViewWrapper() {
//                addSubview(wrapper)
//                wrapper.addSubview(view)
//                wrapper.frame = self.frame
//                wrapper.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
//                view.frame = self.frame
//                view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
//            } else {
//                addSubview(view)
//                view.frame = self.frame
//                view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
//            }
        }
    }

}
