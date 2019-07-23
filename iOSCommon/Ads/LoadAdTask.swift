//
//  LoadAdTask.swift
//  bbmap
//
//  Created by speshiou on 2017/9/25.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class LoadAdTask: Operation {
    
    static let AD_REFRESH_RATE: Double = -1 // unit: seconds
    
    public var adType: String
    
    weak var rootViewController: UIViewController?
    var adViewRecycler: AdViewRecycler
    var adUnitId: String
    var isLoading = false
    var refreshRate = LoadAdTask.AD_REFRESH_RATE
    var loadedTime: Double = 0
    var isReadyForRefresh: Bool {
        get {
            if self.loadedTime == 0 {
                return true
            }
            if self.refreshRate <= 0 {
                return false
            }
            return Date().timeIntervalSince1970 - self.loadedTime > self.refreshRate
        }
    }
    
    public weak var adContainer: AdViewCell? {
        didSet {
            if let adContainer = self.adContainer {
                adContainer.adTask = self
                if !self.isLoading {
                    self.attachAd(to: adContainer)
                }
            }
        }
    }
    
    init(from rootViewController: UIViewController?, adViewRecycler: AdViewRecycler, adType: String, adUnitId: String) {
        self.rootViewController = rootViewController
        self.adViewRecycler = adViewRecycler
        self.adType = adType
        self.adUnitId = adUnitId
        super.init()
    }
    
    override public func main() {
        if self.isLoading {
            return
        }
        if self.isReadyForRefresh {
            willLoad()
        }
    }
    
    func willLoad() {
        self.isLoading = true
        self.loadedTime = Date().timeIntervalSince1970
    }
    
    func didLoad() {
        self.isLoading = false
        if let adContainer = self.adContainer, adContainer.adTask == self {
            self.attachAd(to: adContainer)
            self.notifyAdDidLoad()
        }
    }
    
    func didFail() {
        self.isLoading = false
        self.loadedTime = 0
    }
    
    func attachAd(to cell: AdViewCell) {
//        for subview in cell.contentView.subviews {
//            subview.removeFromSuperview()
//        }
    }
    
    func notifyAdDidLoad() {
        if let delegate = self.rootViewController as? LoadAdTaskDelegate {
            delegate.adDidLoad(adTask: self)
        }
    }
}
