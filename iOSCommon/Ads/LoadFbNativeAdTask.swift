//
//  LoadFbNativeAdTask.swift
//  bbmap
//
//  Created by speshiou on 2017/9/26.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import FBAudienceNetwork

public class LoadFbNativeAdTask: LoadAdTask {
    
    var nativeAd: FBNativeAdBase?
    var pendingNativeAd: FBNativeAdBase?
    
    override func willLoad() {
        super.willLoad()
        
        let nativeAd = self.adType == AdType.AD_FB_NATIVE ? FBNativeAd(placementID: self.adUnitId) : FBNativeBannerAd(placementID: self.adUnitId)
        if let fbBannerAd = nativeAd as? FBNativeBannerAd {
            fbBannerAd.delegate = self
        } else if let fbNativeAd = nativeAd as? FBNativeAd {
            fbNativeAd.delegate = self
        }
        nativeAd.loadAd()
        self.pendingNativeAd = nativeAd
    }
    
    override public func attachAd(to container: UIView) {
        super.attachAd(to: container)
        
        guard let nativeAd = self.nativeAd, let adView = self.adViewRecycler.obtainAdView(identifier: AdViewRecycler.AD_VIEW_FB) as? FBNativeAdView else {
            return
        }
        nativeAd.unregisterView()
        adView.titleLabel.text = nativeAd.advertiserName
        adView.subtitleLabel?.text = nativeAd.socialContext
        adView.adLabel.text = nativeAd.sponsoredTranslation
        adView.captionLabel?.isHidden = true
        adView.bodyLabel?.text = nativeAd.bodyText
        adView.bodyLabel?.isHidden = nativeAd.bodyText == nil
        adView.actionButton.setTitle(nativeAd.callToAction, for: .normal)
        adView.adOptionsView.nativeAd = nativeAd
        let clickableViews = [ adView ] as [UIView]
        if let fbBannerAd = nativeAd as? FBNativeBannerAd {
            fbBannerAd.registerView(forInteraction: adView, iconView: adView.iconView, viewController: self.rootViewController, clickableViews: clickableViews)
        } else if let fbNativeAd = nativeAd as? FBNativeAd {
            fbNativeAd.registerView(forInteraction: adView, mediaView: adView.mediaView, iconView: adView.iconView, viewController: self.rootViewController, clickableViews: clickableViews)
        }
        adView.removeFromSuperview()
        container.addSubview(adView)
        adView.constrainToParent()
    }
    
    

}

extension LoadFbNativeAdTask: FBNativeBannerAdDelegate {
    public func nativeBannerAdDidLoad(_ nativeBannerAd: FBNativeBannerAd) {
        self.nativeAd = nativeBannerAd
        self.pendingNativeAd = nil
        self.didLoad()
    }
    
    public func nativeBannerAd(_ nativeBannerAd: FBNativeBannerAd, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        if self.nativeAd == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
}

extension LoadFbNativeAdTask: FBNativeAdDelegate {
    public func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        self.nativeAd = nativeAd
        self.pendingNativeAd = nil
        self.didLoad()
    }
    
    public func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        if self.nativeAd == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
}
