//
//  InterstitialAdListener.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/12/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation

public protocol InterstitialAdListener: AnyObject {
    func onAdLoaded()
    func onAdDismissed()
    func onAdClicked()
    func onAdDisplayed()
    func onError()
}
