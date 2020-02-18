//
//  EmptyViewData.swift
//  iOSCommon
//
//  Created by Pei-shiou Huang on 2/18/20.
//  Copyright © 2020 YUHO. All rights reserved.
//

import Foundation

open class EmptyViewData: NSObject {
    public var icon: UIImage? = nil
    public var message = ""
    public var actionButtonText: String? = nil
    public var actionButtonDidClick: (() -> Void)? = nil
}
