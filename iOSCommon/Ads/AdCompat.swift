//
//  AdCompat.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/31/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import Firebase

class AdCompat {
    class func parseBannerSizes(_ s: String) -> [GADAdSize] {
        let bannerSizes = s.split(separator: ",").map {
            (size) -> String in
            return size.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var sizes = [GADAdSize]()
        for size in bannerSizes {
            switch (size) {
            case "BANNER":
                sizes.append(kGADAdSizeBanner)
                break
            case "FULL_BANNER":
                sizes.append(kGADAdSizeFullBanner)
                break
            case "LARGE_BANNER":
                sizes.append(kGADAdSizeLargeBanner)
                break
            case "LEADERBOARD":
                sizes.append(kGADAdSizeLeaderboard)
                break
            case "MEDIUM_RECTANGLE":
                sizes.append(kGADAdSizeMediumRectangle)
                break
            case "WIDE_SKYSCRAPER":
                sizes.append(kGADAdSizeSkyscraper)
                break
            case "SMART_BANNER":
                sizes.append(kGADAdSizeSmartBannerPortrait)
                break
            case "FLUID":
                sizes.append(kGADAdSizeFluid)
                break
            default:
                break
            }
        }
        return sizes
    }
    
    class func logImpressionEvent(adType: String, adId: String) {
        Analytics.logEvent("ad_impression_ab", parameters: [
            "ad_type": adType as NSObject,
            "ad_id": adId as NSObject
            ])
    }
    
    class func logClickEvent(adType: String, adId: String) {
        Analytics.logEvent("ad_click_ab", parameters: [
            "ad_type": adType as NSObject,
            "ad_id": adId as NSObject
            ])
    }
}
