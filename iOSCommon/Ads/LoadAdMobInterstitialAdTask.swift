//
//  LoadAdMobInterstitialAdTask.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import FirebaseCore
import GoogleMobileAds

public class LoadAdMobInterstitialAdTask: LoadInterstitialAdTask {
    private var interstitialAd: GADInterstitial?
    
    override func onLoad() {
        super.onLoad()
        interstitialAd = GADInterstitial(adUnitID: self.adId)
        interstitialAd?.delegate = self
        
        // For auto play video ads, it's recommended to load the ad
        // at least 30 seconds before it is shown
        interstitialAd?.load(GADRequest())
    }
    
    override public func show() {
        super.show()
        guard let vc = self.rootViewController else {
            return
        }
        interstitialAd?.present(fromRootViewController: vc)
    }
    
    override func destroy() {
        super.destroy()
    }
    
    override func isAdInvalidated() -> Bool {
        return !isAdLoaded()
    }
    
    override public func isAdLoaded() -> Bool {
        return interstitialAd?.isReady ?? false
    }
}

extension LoadAdMobInterstitialAdTask: GADInterstitialDelegate {
    public func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        delegate?.onAdDisplayed()
        
        AdCompat.logImpressionEvent(adType: adType, adId: adId)
    }
    
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        delegate?.onAdDismissed()
    }
    
    public func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        delegate?.onAdClicked()
        
        AdCompat.logClickEvent(adType: adType, adId: adId)
    }
    
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        delegate?.onAdLoaded()
    }
    
    public func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
    }
    
    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        delegate?.onError()
    }
}
