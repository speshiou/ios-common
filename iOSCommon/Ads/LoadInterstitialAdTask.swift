//
//  LoadInterstitialAdTask.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import UIKit

public class LoadInterstitialAdTask: NSObject {
    
    weak var delegate: InterstitialAdListener?
    weak var rootViewController: UIViewController?
    var adType = ""
    var adId = ""
    
    init(from rootViewController: UIViewController, adType: String, adId: String) {
        self.adType = adType
        self.adId = adId
        self.rootViewController = rootViewController
    }
    
    func load() {
        onLoad()
    }
    
    func onLoad() {
        
    }
    
    func destroy() {
        
    }
    
    func show() {
        
    }
    
    func isAdInvalidated() -> Bool {
        return true
    }
    
    func isAdLoaded() -> Bool {
        return false
    }
}
