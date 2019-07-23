//
//  LoadFbInterstitialAdTask.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import FBAudienceNetwork

public class LoadFbInterstitialAdTask: LoadInterstitialAdTask {
    private var interstitialAd: FBInterstitialAd?
    
    override func onLoad() {
        super.onLoad()
        interstitialAd = FBInterstitialAd(placementID: self.adId)
        interstitialAd?.delegate = self
        
        // For auto play video ads, it's recommended to load the ad
        // at least 30 seconds before it is shown
        interstitialAd?.load()
    }
    
    override func show() {
        super.show()
        guard let vc = self.rootViewController else {
            return
        }
        interstitialAd?.show(fromRootViewController: vc)
    }
    
    override func destroy() {
        super.destroy()
    }
    
    override func isAdInvalidated() -> Bool {
        return !isAdLoaded()
    }
    
    override func isAdLoaded() -> Bool {
        return interstitialAd?.isAdValid ?? false
    }
}

extension LoadFbInterstitialAdTask: FBInterstitialAdDelegate {
    
    public func interstitialAdWillLogImpression(_ interstitialAd: FBInterstitialAd) {
        delegate?.onAdDisplayed()
        
        AdCompat.logImpressionEvent(adType: adType, adId: adId)
    }
    
    public func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        delegate?.onAdDismissed()
    }
    
    public func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {
        delegate?.onAdClicked()
        
        AdCompat.logClickEvent(adType: adType, adId: adId)
    }
    
    public func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        delegate?.onAdLoaded()
    }
    
    public func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        delegate?.onError()
    }

}
