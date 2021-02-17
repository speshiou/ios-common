//
//  LoadDfpBannerAdTask.swift
//  bbmap
//
//  Created by speshiou on 2017/9/25.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class LoadDfpBannerAdTask: LoadAdTask {
    
    var bannerView: GAMBannerView?
    var pendingBannerView: GAMBannerView?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func willLoad() {
        super.willLoad()
        
        let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let height = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let bannerView = GAMBannerView(adSize: kGADAdSizeFluid)
        bannerView.adUnitID = self.adUnitId
        bannerView.rootViewController = self.rootViewController
        bannerView.delegate = self
        bannerView.adSizeDelegate = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.widthConstraint = bannerView.widthAnchor.constraint(equalToConstant: width)
        self.widthConstraint?.isActive = true
        self.heightConstraint = bannerView.heightAnchor.constraint(equalToConstant: height)
        self.heightConstraint?.isActive = true
        var values = [NSValue]()
        for adSize in self.adViewRecycler.dfpBannerAdSizes {
            values.append(NSValueFromGADAdSize(adSize))
        }
        bannerView.validAdSizes = values
        let adRequest = GAMRequest()
        #if DEBUG
//        adRequest.testDevices = [ "3bb15d73acc9737699e9bc06c09715dd" ]
        #endif
        
        bannerView.load(adRequest)
        
        self.pendingBannerView = bannerView
    }
    
    override public func attachAd(to container: UIView) {
        super.attachAd(to: container)
        
        guard let bannerView = self.bannerView else {
            return
        }
        bannerView.removeFromSuperview()
        container.addSubview(bannerView)
        //        bannerView.constrainToParent()
        bannerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }
}

extension LoadDfpBannerAdTask: GADBannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerView = bannerView as? GAMBannerView
        self.pendingBannerView = nil
        self.didLoad()
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        NSLog(error.localizedDescription)
        if self.bannerView == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
    
    public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDismissScreen")
    }
}

extension LoadDfpBannerAdTask: GADAdSizeDelegate {
    public func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        var isFluid = true
        for adSize in self.adViewRecycler.dfpBannerAdSizes {
            if adSize.size.width == size.size.width && adSize.size.height == size.size.height {
                isFluid = false
                break
            }
        }
        
        self.widthConstraint?.constant = size.size.width
        self.heightConstraint?.constant = size.size.height
        if isFluid && !self.isLoading {
            self.notifyAdDidLoad()
        }
    }
}
