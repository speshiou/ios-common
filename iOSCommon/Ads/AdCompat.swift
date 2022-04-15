//
//  AdCompat.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/31/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

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
    
    class public func parseBannerSizes(_ s: String) -> [GADAdSize] {
        let bannerSizes = s.split(separator: ",").map {
            (size) -> String in
            return size.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var sizes = [GADAdSize]()
        for size in bannerSizes {
            switch (size) {
            case "BANNER":
                sizes.append(GADAdSizeBanner)
                break
            case "FULL_BANNER":
                sizes.append(GADAdSizeFullBanner)
                break
            case "LARGE_BANNER":
                sizes.append(GADAdSizeLargeBanner)
                break
            case "LEADERBOARD":
                sizes.append(GADAdSizeLeaderboard)
                break
            case "MEDIUM_RECTANGLE":
                sizes.append(GADAdSizeMediumRectangle)
                break
            case "WIDE_SKYSCRAPER":
                sizes.append(GADAdSizeSkyscraper)
                break
            case "FLUID":
                sizes.append(GADAdSizeFluid)
                break
            default:
                break
            }
        }
        return sizes
    }
    
    class func logImpressionEvent(adType: String, adId: String) {

    }
    
    class func logClickEvent(adType: String, adId: String) {

    }
}
