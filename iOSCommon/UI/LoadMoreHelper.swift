//
//  LoadMoreHelper.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/7/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import Foundation

class LoadMoreHelper {
    
    var loadMoreRecords = [Int: SessionStatus]()
    
    func updateLoadMoreRecord(section: Int, hasMoreData: Bool, loadMoreBundle: [String: Any]?) {
        var status = self.loadMoreRecords[section]
        if status == nil {
            status = SessionStatus()
        }
        status?.isLoading = false
        status?.hasMoreData = hasMoreData
        status?.bundle = loadMoreBundle
        self.loadMoreRecords[section] = status
    }
    
    func hasMoreData(section: Int) -> Bool {
        if let record = self.loadMoreRecords[section] {
            return record.hasMoreData
        } else {
            return false
        }
    }
    
    func loadData(section: Int) -> [String: Any]? {
        if let record = self.loadMoreRecords[section] {
            record.isLoading = true
            return record.bundle
        }
        return nil
    }
    
    func isLoading(section: Int) -> Bool {
        if let record = self.loadMoreRecords[section] {
            return record.isLoading
        }
        return false
    }
}

class SessionStatus {
    var isLoading = false
    var hasMoreData = false
    var bundle: [String: Any]?
}
