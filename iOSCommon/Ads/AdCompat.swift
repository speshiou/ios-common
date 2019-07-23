//
//  AdCompat.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/31/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import FirebaseCore
import GoogleMobileAds
import FirebaseAnalytics

public class AdCompat {
    public static let AD_FB_NATIVE = 101
    public static let AD_DFP = 102
    public static let AD_ADMOB_NATIVE_ADV = 103
    public static let AD_ADMOB_NATIVE_EXP = 104
    public static let AD_DFP_BANNER = 105
    public static let AD_CSA = 106
    
    public static func toNewAdType(adType: Int) -> String {
        switch (adType) {
        case AD_FB_NATIVE:
            return AdType.AD_FB_NATIVE_BANNER
        case AD_DFP:
            return AdType.AD_DFP
        case AD_ADMOB_NATIVE_ADV:
            return AdType.AD_ADMOB_NATIVE
        case AD_ADMOB_NATIVE_EXP:
            return AdType.AD_ADMOB_NATIVE
        case AD_DFP_BANNER:
            return AdType.AD_DFP_BANNER
        case AD_CSA:
            return AdType.AD_CSA
        default:
            return ""
        }
    }
    
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
