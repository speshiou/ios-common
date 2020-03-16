//
//  LoadAFSNativeTask.swift
//  iOSCommon
//
//  Created by Pei-shiou Huang on 3/16/20.
//  Copyright © 2020 YUHO. All rights reserved.
//

import Foundation
import AFSNative

public class LoadAFSNativeTask: LoadAdTask {
    
    public var size = CGSize.zero
    public var page = -1
    
    var adController: GANSearchAdController?
    var adView: GANAdView?
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
        
        let unitIds = self.adUnitId.components(separatedBy: "/")
        let publisherID = unitIds[0]
        let channelID = unitIds[1]
        let styleID = unitIds[2]

//        let width = min(self.rootViewController?.view.bounds.width ?? 320, self.rootViewController?.view.bounds.height ?? 320) - padding
//        bannerView.rootViewController = self.rootViewController
//        bannerView.frame = CGRect(x: 0, y: 0, width: width, height: 0)
//        bannerView.autoresizingMask = .flexibleWidth
//        bannerView.adSizeDelegate = self
//        bannerView.delegate = self
        
        let options = GANSearchAdControllerOptions()
        options.isPrefetchEnabled = true
        options.adType = .text
        options.adFetchCount = 3
        options.channel = channelID
        
        adController = GANSearchAdController(publisherID: publisherID, styleID: styleID, options: options, delegate: self)
        
        let adRequest = GANSearchAdRequest()
        adRequest.query = keyword

        adController?.loadAds(adRequest)
        //        adRequest.testDevices = [ kGADSimulatorID ]
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        self.heightConstraint = bannerView.heightAnchor.constraint(equalToConstant: 0)
//        self.heightConstraint?.isActive = true
//        bannerView.load(adRequest)
//        self.pendingBannerView = bannerView
    }
    
    override public func attachAd(to container: UIView) {
        super.attachAd(to: container)
        
        guard let adView = self.adView else {
            return
        }
        adView.removeFromSuperview()
        container.addSubview(adView)
        adController?.populateAdView(adView, identifier: "demoAd")
//        adView.constrainToParent(insets: UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0))
    }
    
}

extension LoadAFSNativeTask: GANSearchAdControllerDelegate {
    public func searchAdController(_ adController: GANSearchAdController, didLoadAds numberOfAds: Int) {
        if numberOfAds <= 0 {
            NSLog("No ads found on the server")
        } else {
            self.adView = adController.adView()
            self.didLoad()
        }
    }
    
    public func searchAdController(_ adController: GANSearchAdController, didFailWithError error: Error) {
        self.didFail()
    }
}
