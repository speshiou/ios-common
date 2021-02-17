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

public class LoadDfpInterstitialAdTask: LoadInterstitialAdTask {
    private var interstitialAd: GADInterstitialAd?
    
    override func onLoad() {
        super.onLoad()
        // For auto play video ads, it's recommended to load the ad
        // at least 30 seconds before it is shown)
        let adRequest = GAMRequest()
        #if DEBUG
//        adRequest.testDeviceIdentifiers = [ "3bb15d73acc9737699e9bc06c09715dd" ]
        #endif
        GAMInterstitialAd.load(withAdManagerAdUnitID: self.adId, request: adRequest) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.delegate?.onAdLoaded()
        }
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
        return interstitialAd != nil
    }
}

extension LoadDfpInterstitialAdTask: GADFullScreenContentDelegate {
    public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.onAdDisplayed()
    }
    
    public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        AdCompat.logImpressionEvent(adType: adType, adId: adId)
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[DFP] \(error.localizedDescription)")
        delegate?.onError()
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.onAdDismissed()
    }
}
