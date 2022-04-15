//
//  AdViewRecycler.swift
//  bbmap
//
//  Created by speshiou on 2017/9/26.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

public class AdViewRecycler {
    static let AD_VIEW_FB = "ad_view_fb"
    static let AD_VIEW_GOOGLE = "ad_view_google"
    static let AD_VIEW_CSA = "ad_view_csa"
    
    static let AD_VIEW_CELL_ID = "ad_view_cell"
    
    weak var rootViewController: UIViewController?
    var adViewMap = [ String: [UIView] ]()
    public var admobNativeAdViewNibName = "AdmobNativeAdView"
    public var fbNativeAdViewNibName = "FBNativeBannerAdView"
    public var adViewCellNibName: String?
    public var dfpBannerAdSizes = [GADAdSize]()
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    public class func getAdViewCellIdentifier(adType: String) -> String {
        return AdViewRecycler.AD_VIEW_CELL_ID
    }
    
    public func registerAdCells(to tableView: UITableView) {
        if let nibName = self.adViewCellNibName {
            tableView.register(UINib.init(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: AdViewRecycler.AD_VIEW_CELL_ID)
        } else {
            tableView.register(UINib.init(nibName: "AdViewCell", bundle: PodHelper.bundle), forCellReuseIdentifier: AdViewRecycler.AD_VIEW_CELL_ID)
        }
    }
    
    func obtainAdView(identifier: String) -> UIView? {
        var views = adViewMap[identifier] ?? [UIView]()
        var reusedAdView: UIView?
        for view in views {
            if view.superview == nil {
                reusedAdView = view
                break
            }
        }
        if reusedAdView == nil {
            switch (identifier) {
            case AdViewRecycler.AD_VIEW_FB:
                reusedAdView = FBNativeAdView(nibName: self.fbNativeAdViewNibName)
                break
            case AdViewRecycler.AD_VIEW_GOOGLE:
                reusedAdView = AdmobNativeAdView(nibName: self.admobNativeAdViewNibName)
                break
            default:
                break
            }
            if let adView = reusedAdView {
                views.append(adView)
            }
        }
        adViewMap[identifier] = views
        return reusedAdView
    }
}
