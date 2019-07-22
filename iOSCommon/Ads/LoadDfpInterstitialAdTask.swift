//
//  LoadDfpInterstitialAdTask.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import FirebaseCore
import GoogleMobileAds

class LoadDfpInterstitialAdTask: LoadInterstitialAdTask {
    private var interstitialAd: GADInterstitial?
    
    override func onLoad() {
        super.onLoad()
        interstitialAd = DFPInterstitial(adUnitID: self.adId)
        interstitialAd?.delegate = self
        
        // For auto play video ads, it's recommended to load the ad
        // at least 30 seconds before it is shown
        let adRequest = DFPRequest()
        #if DEBUG
        adRequest.testDevices = [ "3bb15d73acc9737699e9bc06c09715dd" ]
        #endif
        interstitialAd?.load(adRequest)
    }
    
    override func show() {
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
    
    override func isAdLoaded() -> Bool {
        return interstitialAd?.isReady ?? false
    }
}

extension LoadDfpInterstitialAdTask: GADInterstitialDelegate {
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        delegate?.onAdDisplayed()
        
        AdCompat.logImpressionEvent(adType: adType, adId: adId)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        delegate?.onAdDismissed()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        delegate?.onAdClicked()
        
        AdCompat.logClickEvent(adType: adType, adId: adId)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        delegate?.onAdLoaded()
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("[DFP] \(error.localizedDescription)")
        delegate?.onError()
    }
}
