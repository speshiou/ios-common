//
//  AdUtils.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/13/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation

class AdUtils {
    class func insertAdData(adRecycler: AdRecycler, data: [Any], adPositions: [Int], adType: String, adId: String) -> [Any] {
        if (!data.isEmpty && AdType.allTypes.contains(adType) && !adPositions.isEmpty && !adType.isEmpty && !adId.isEmpty) {
            var updatedData = [Any]()
            updatedData += data
            var admobTask: LoadAdTask? = nil
            let admobNumInBundle = 2
            for (index, pos) in adPositions.enumerated() {
                if (pos > -1) {
                    var insertToIndex = -1
                    if pos <= data.count {
                        insertToIndex = pos + index
                        
                    } else if !(updatedData[updatedData.count - 1] is LoadAdTask) {
//                        insertToIndex = updatedData.count
                    }
                    if (adType == AdType.AD_ADMOB_NATIVE && index % admobNumInBundle == 0) {
                        admobTask = getAdData(adRecycler: adRecycler, adType: adType, adId: adId, index: -1, totalAds: admobNumInBundle)
                    }
                    if (insertToIndex > -1) {
                        var adTask: LoadAdTask? = nil
                        if let admobTask = admobTask {
                            if admobTask is LoadAdTaskAdapter {
                                adTask = admobTask
                            } else {
                                adTask = LoadAdTaskAdapter(loadAdTask: admobTask, adIndex: index % admobNumInBundle)
                            }
                        } else {
                            adTask = getAdData(adRecycler: adRecycler, adType: adType, adId: adId, index: index, totalAds: adPositions.count)
                        }
                        if let adTask = adTask {
                            updatedData.insert(adTask, at: insertToIndex)
                        }
                    }
                }
            }
            return updatedData
        } else {
            return data
        }
    }
    
    private class func getAdData(adRecycler: AdRecycler, adType: String, adId: String, index: Int, totalAds: Int) -> LoadAdTask? {
        
        if let adTask = adRecycler.obtainLoadAdTask(adType, adUnitId: adId, refreshRate: 60) {
            if let adTask = adTask as? LoadCSATask {
                adTask.page = index + 1
            } else if let adTask = adTask as? LoadAdmobNativeAdvTask {
                adTask.adCount = totalAds
                adTask.refreshRate = 60 * 5
            }
            return adTask
        }
        return nil
    }
    
    static let PRELOAD_AD_AHEAD = 10
    class func preloadAds(data: [Any], from position: Int) -> Void {
        let adPreloadStart = position < PRELOAD_AD_AHEAD ? position : position + PRELOAD_AD_AHEAD - 1
        for adPos in adPreloadStart..<position + PRELOAD_AD_AHEAD {
            if adPos >= 0 && adPos < data.count {
                if let obj = data[adPos] as? LoadAdTask {
                    obj.main()
                }
            }
        }
    }
}
