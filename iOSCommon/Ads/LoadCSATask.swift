//
//  LoadCSATask.swift
//  bbmap
//
//  Created by speshiou on 2018/1/31.
//  Copyright © 2018年 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class LoadCSATask: LoadAdTask, GADBannerViewDelegate, GADAdSizeDelegate {
    
    public var size = CGSize.zero
    public var page = -1
    
    var bannerView: GADSearchBannerView?
    var pendingBannerView: GADSearchBannerView?
    var keyword: String?
    var padding: CGFloat = 12
    var heightConstraint: NSLayoutConstraint?
    
    init(from rootViewController: UIViewController, adViewRecycler: AdViewRecycler, adType: String, adUnitId: String, keyword: String?) {
        super.init(from: rootViewController, adViewRecycler: adViewRecycler, adType: adType, adUnitId: adUnitId)
        self.keyword = keyword
    }
    
    override func willLoad() {
        super.willLoad()
        guard let keyword = self.keyword else {
            self.didFail()
            return
        }
        
        let bannerView = GADSearchBannerView(adSize: kGADAdSizeFluid)
        let unitIds = self.adUnitId.components(separatedBy: "/")
        if !unitIds.isEmpty {
            bannerView.adUnitID = unitIds[0]
        }
        let width = min(self.rootViewController?.view.bounds.width ?? 320, self.rootViewController?.view.bounds.height ?? 320) - padding
        bannerView.rootViewController = self.rootViewController
        bannerView.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        bannerView.autoresizingMask = .flexibleWidth
        bannerView.adSizeDelegate = self
        bannerView.delegate = self
        let adRequest = GADDynamicHeightSearchRequest()
        adRequest.query = keyword
        if unitIds.count > 1 {
            adRequest.channel = unitIds[1]
        }
        adRequest.numberOfAds = 1
        adRequest.adPage = page
        adRequest.cssWidth = "\(width)"
        adRequest.sellerRatingsExtensionEnabled = true
        adRequest.boldTitleEnabled = true
        adRequest.titleFontSize = 16
        adRequest.titleLinkColor = "#141823"
        adRequest.textColor = "#3C3F45"
        adRequest.titleUnderlineHidden = true
        adRequest.longerHeadlinesExtensionEnabled = false
        adRequest.locationExtensionEnabled = false
        adRequest.siteLinksExtensionEnabled = false
        adRequest.sellerRatingsExtensionEnabled = false
        adRequest.detailedAttributionExtensionEnabled = false
        adRequest.domainLinkColor = "#9197A3"
        adRequest.clickToCallExtensionEnabled = false
        adRequest.setAdvancedOptionValue("false", forKey: "detailedAttribution")
        adRequest.setAdvancedOptionValue("false", forKey: "domainLinkAboveDescription")
        //        adRequest.testDevices = [ kGADSimulatorID ]
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = bannerView.heightAnchor.constraint(equalToConstant: 0)
        self.heightConstraint?.isActive = true
        bannerView.load(adRequest)
        self.pendingBannerView = bannerView
    }
    
    override func attachAd(to container: UIView) {
        super.attachAd(to: container)
        
        guard let bannerView = bannerView else {
            return
        }
        bannerView.removeFromSuperview()
        container.addSubview(bannerView)
        bannerView.constrainToParent(insets: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0))
    }
    
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerView = bannerView as? GADSearchBannerView
        self.pendingBannerView = nil
        self.didLoad()
    }
    
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog(error.localizedDescription)
        if self.bannerView == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
    
    public func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        self.size = size.size
        self.heightConstraint?.constant = self.size.height
        
        self.notifyAdDidLoad()
    }
}

