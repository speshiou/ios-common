//
//  InterstitialAdManager.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import UIKit

class InterstitialAdManager {
    
    class func createLoadAdTask(rootViewController: UIViewController, adType: String, unitId: String) -> LoadInterstitialAdTask? {
        var task: LoadInterstitialAdTask? = nil
        let unitId = unitId.trimmingCharacters(in: .whitespacesAndNewlines)
        if !unitId.isEmpty {
            if (adType == InterstitialAdType.FB) {
                task = LoadFbInterstitialAdTask(from: rootViewController, adType: adType, adId: unitId)
            } else if (adType == InterstitialAdType.ADMOB) {
                task = LoadAdMobInterstitialAdTask(from: rootViewController, adType: adType, adId: unitId)
            } else if (adType == InterstitialAdType.DFP) {
                task = LoadDfpInterstitialAdTask(from: rootViewController, adType: adType, adId: unitId)
            }
        }
        return task
    }
    
}
