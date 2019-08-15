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
    
    public weak var delegate: InterstitialAdListener?
    weak var rootViewController: UIViewController?
    var adType = ""
    var adId = ""
    
    init(from rootViewController: UIViewController, adType: String, adId: String) {
        self.adType = adType
        self.adId = adId
        self.rootViewController = rootViewController
    }
    
    public func load() {
        onLoad()
    }
    
    func onLoad() {
        
    }
    
    func destroy() {
        
    }
    
    public func show() {
        
    }
    
    func isAdInvalidated() -> Bool {
        return true
    }
    
    public func isAdLoaded() -> Bool {
        return false
    }
}
