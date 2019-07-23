//
//  LoadAdmobNativeAdvTask.swift
//  bbmap
//
//  Created by speshiou on 2017/9/26.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class LoadAdmobNativeAdvTask: LoadAdTask {
    
    var adLoader: GADAdLoader!
    var nativeAd: GADUnifiedNativeAd?
    var dfpBannerView: DFPBannerView?
    var adCount = 1
    
    override func willLoad() {
        super.willLoad()
        var adTypes: [GADAdLoaderAdType] = [ .unifiedNative ]
        if adType == AdType.AD_DFP || adType == AdType.AD_DFP_BANNER {
            adTypes.append(.dfpBanner)
        }
        let mediaOption = GADNativeAdMediaAdLoaderOptions()
        mediaOption.mediaAspectRatio = .landscape
        adLoader = GADAdLoader(adUnitID: adUnitId, rootViewController: rootViewController, adTypes: adTypes, options: [ mediaOption ])
        adLoader.delegate = self
        if adType == AdType.AD_ADMOB_NATIVE {
            adLoader.load(GADRequest())
        } else if adType == AdType.AD_DFP || adType == AdType.AD_DFP_BANNER {
            adLoader.load(DFPRequest())
        }
    }
    
    override func attachAd(to adViewCell: AdViewCell) {
        super.attachAd(to: adViewCell)
        let wrapper = adViewCell.wrapper ?? adViewCell.contentView
        if let nativeAd = self.nativeAd, let adView = self.adViewRecycler.obtainAdView(identifier: AdViewRecycler.AD_VIEW_GOOGLE) as? AdmobNativeAdView {
            self.populateAdView(adView: adView, nativeAd: nativeAd)
            wrapper.addSubview(adView)
            adView.constrainToParent()
        } else if let dfpBannerView = self.dfpBannerView {
            dfpBannerView.removeFromSuperview()
            wrapper.addSubview(dfpBannerView)
            dfpBannerView.constrainToParent()
        }
    }
    
    func populateAdView(adView: AdmobNativeAdView, nativeAd: GADUnifiedNativeAd) {
        adView.nativeAdView.nativeAd = nativeAd
        adView.titleLabel.text = nativeAd.headline
        if let price = nativeAd.price, !price.isEmpty {
            adView.subtitleLabel?.isHidden = false
            adView.subtitleLabel?.text = price
        } else {
            adView.subtitleLabel?.isHidden = true
        }
        if let store = nativeAd.store, !store.isEmpty {
            adView.captionLabel?.isHidden = false
            adView.captionLabel?.text = nativeAd.store
        } else {
            adView.captionLabel?.isHidden = true
        }
        adView.ratingBar?.isHidden = true
        adView.secondaryLineSection?.isHidden = adView.subtitleLabel?.isHidden ?? true && adView.captionLabel?.isHidden ?? true
        adView.bodyLabel.text = nativeAd.body
        if let icon = nativeAd.icon?.image {
            adView.iconImageView.image = icon
            adView.iconImageView.isHidden = false
        } else {
            adView.iconImageView.isHidden = true
        }
        adView.actionButton.setTitle(nativeAd.callToAction, for: .normal)
        adView.nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        if adView.mediaView != nil {
            if nativeAd.mediaContent.aspectRatio > 0 {
                let height = adView.mediaView.bounds.width / nativeAd.mediaContent.aspectRatio
                adView.mediaHeight?.constant = height
            } else {
                adView.mediaHeight?.constant = 0
            }
        }
    }
}

extension LoadAdmobNativeAdvTask: GADAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog(error.localizedDescription)
        if self.nativeAd == nil && self.dfpBannerView == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
}

extension LoadAdmobNativeAdvTask: GADUnifiedNativeAdLoaderDelegate {
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        self.nativeAd = nativeAd
        self.dfpBannerView = nil
        self.didLoad()
    }
}

extension LoadAdmobNativeAdvTask: DFPBannerAdLoaderDelegate {
    public func validBannerSizes(for adLoader: GADAdLoader) -> [NSValue] {
        var values = [NSValue]()
        for adSize in self.adViewRecycler.dfpBannerAdSizes {
            values.append(NSValueFromGADAdSize(adSize))
        }
        return values
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive bannerView: DFPBannerView) {
        self.dfpBannerView = bannerView
        self.nativeAd = nil
        self.didLoad()
    }
}
