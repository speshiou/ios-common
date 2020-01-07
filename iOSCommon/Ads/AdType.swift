//
//  AdType.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/13/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation

open class AdType {
    public static let AD_FB_NATIVE = "FB_NATIVE"
    public static let AD_FB_NATIVE_BANNER = "FB_NATIVE_BANNER"
    public static let AD_DFP = "DFP"
    public static let AD_DFP_BANNER = "DFP_BANNER"
    public static let AD_ADMOB_NATIVE = "ADMOB_NATIVE"
    public static let AD_CSA = "CSA"
    
    public static let allTypes = [
        AD_FB_NATIVE,
        AD_DFP,
        AD_DFP_BANNER,
        AD_ADMOB_NATIVE,
        AD_CSA,
        AD_FB_NATIVE_BANNER
    ]
}
