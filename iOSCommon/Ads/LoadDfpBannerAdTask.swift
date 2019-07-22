//
//  LoadDfpBannerAdTask.swift
//  bbmap
//
//  Created by speshiou on 2017/9/25.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

class LoadDfpBannerAdTask: LoadAdTask {
    
    var bannerView: DFPBannerView?
    var pendingBannerView: DFPBannerView?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func willLoad() {
        super.willLoad()
        
        let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let height = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let bannerView = DFPBannerView(adSize: kGADAdSizeFluid)
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
        let adRequest = DFPRequest()
        #if DEBUG
//        adRequest.testDevices = [ "3bb15d73acc9737699e9bc06c09715dd" ]
        #endif
        
        bannerView.load(adRequest)
        
        self.pendingBannerView = bannerView
    }
    
    override func attachAd(to adViewCell: AdViewCell) {
        super.attachAd(to: adViewCell)
        
        guard let bannerView = self.bannerView else {
            return
        }
        bannerView.removeFromSuperview()
        let wrapper = adViewCell.wrapper ?? adViewCell.contentView
        wrapper.addSubview(bannerView)
        //        bannerView.constrainToParent()
        bannerView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 0).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: 0).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
    }
}

extension LoadDfpBannerAdTask: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerView = bannerView as? DFPBannerView
        self.pendingBannerView = nil
        self.didLoad()
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog("\(error.code) \(error.localizedDescription)")
        if self.bannerView == nil {
            self.didFail()
        } else {
            self.didLoad()
        }
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

extension LoadDfpBannerAdTask: GADAdSizeDelegate {
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
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
