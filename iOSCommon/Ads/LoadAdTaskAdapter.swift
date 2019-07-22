//
//  LoadAdTaskAdapter.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 2/13/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation
import UIKit

class LoadAdTaskAdapter: LoadAdTask {
    var loadAdTask: LoadAdTask
    var adIndex: Int
    
    init(loadAdTask: LoadAdTask, adIndex: Int) {
        self.loadAdTask = loadAdTask
        self.adIndex = adIndex
        super.init(from: loadAdTask.rootViewController, adViewRecycler: loadAdTask.adViewRecycler, adType: loadAdTask.adType, adUnitId: loadAdTask.adUnitId)
    }
    
    override func main() {
        loadAdTask.main()
    }
    
    override var adContainer: AdViewCell? {
        didSet {
            loadAdTask.adContainer = self.adContainer
        }
    }
}
