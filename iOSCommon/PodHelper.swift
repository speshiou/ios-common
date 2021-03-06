//
//  PodHelper.swift
//  iOSCommon
//
//  Created by Pei-shiou Huang on 7/23/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation

class PodHelper {
    static let podName = "iOSCommon"
    
    static let bundle = { () -> Bundle in
        let frameworkBundle = Bundle(for: AdViewRecycler.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("\(PodHelper.podName).bundle")
        return Bundle(url: bundleURL!)!
    }()
}
