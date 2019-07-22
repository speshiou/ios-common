//
//  AdRecycler.swift
//  bbmap
//
//  Created by speshiou on 2017/9/25.
//  Copyright © 2017年 YUHO. All rights reserved.
//

import Foundation
import UIKit

class AdRecycler {
    weak var rootViewController: UIViewController?
    var adViewRecycler: AdViewRecycler!
    var adTaskMap = [ String: [LoadAdTask]]()
    var keyword: String?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.adViewRecycler = AdViewRecycler(rootViewController: rootViewController)
    }
    
    func obtainLoadAdTask(_ adType: String, adUnitId: String, refreshRate: Double) -> LoadAdTask? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        var reusedAdTask: LoadAdTask?
        var tasks = adTaskMap[adType]
        if tasks == nil {
            tasks = [LoadAdTask]()
            adTaskMap[adType] = tasks
        }
        if let tasks = tasks {
            for (i, task) in tasks.enumerated() {
                if task.adUnitId == adUnitId {
                    reusedAdTask = task
                    adTaskMap[adType]?.remove(at: i)
                    break
                }
            }
            
            if reusedAdTask == nil {
                switch (adType) {
                case AdType.AD_FB_NATIVE:
                    reusedAdTask = LoadFbNativeAdTask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId)
                    break
                case AdType.AD_FB_NATIVE_BANNER:
                    reusedAdTask = LoadFbNativeAdTask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId)
                    break
                case AdType.AD_DFP:
                    reusedAdTask = LoadAdmobNativeAdvTask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId)
                    break
                case AdType.AD_DFP_BANNER:
                    reusedAdTask = LoadDfpBannerAdTask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId)
                    break
                case AdType.AD_ADMOB_NATIVE:
                    reusedAdTask = LoadAdmobNativeAdvTask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId)
                    break
                case AdType.AD_CSA:
                    reusedAdTask = LoadCSATask(from: rootViewController, adViewRecycler: self.adViewRecycler, adType: adType, adUnitId: adUnitId, keyword: self.keyword)
                    break
                default:
                    break
                }
                
            }
        }
        if let csa = reusedAdTask as? LoadCSATask {
            csa.keyword = self.keyword
        }
        reusedAdTask?.refreshRate = refreshRate
        return reusedAdTask
    }
    
    func recycleLoadAdTask(_ adType: String, adTask: LoadAdTask) {
        var tasks = adTaskMap[adType]
        if tasks == nil {
            tasks = [LoadAdTask]()
            adTaskMap[adType] = tasks
        }
        adTaskMap[adType]?.append(adTask)
    }
}
