//
//  BaseTableViewController.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/7/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class BaseTableViewController: UITableViewController {
    
    public static let CELL_ID_EMPTY_VIEW = "EmptyViewCell"
    public static let KEY_PAGE = "key_page"
    
    static let CELL_TYPE_DATA = -1
    static let CELL_TYPE_LOAD_MORE = -2
    open var preloadMoreAhead = 10
    
    public weak var scrollDelegate: BaseTableViewControllerScrollDelegate?
    
    var cachedCellHeights = [ Int: [CGFloat?]]()
    
    var isScrolling = false {
        didSet {
            if !self.isScrolling {
                var rows = [IndexPath]()
                for row in self.pendingReloadRows {
                    if self.tableView.indexPathsForVisibleRows?.contains(where: { (indexPath) -> Bool in
                        return indexPath.section == row.section && indexPath.row == row.row
                        }) ?? false {
                        rows.append(row)
                    }
                }
                self.pendingReloadRows.removeAll()
                self.reloadRows(at: rows)
            }
        }
    }
    var pendingReloadRows = [IndexPath]()
    
    let loadMoreHelper = LoadMoreHelper()
    
    public var emptyView: EmptyView? {
        didSet {
            if let emptyView = self.emptyView {
                emptyView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(emptyView)
                
                if #available(iOS 11.0, *) {
                    let guide = self.view.safeAreaLayoutGuide
                    emptyView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true
                    emptyView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
                    emptyView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
                    emptyView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0).isActive = true
                } else {
                    // Fallback on earlier versions
                    if let guide = self.view {
                        emptyView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true
                        emptyView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
                        emptyView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
                        emptyView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0).isActive = true
                    }
                }
                
                emptyView.layer.zPosition = 100
                emptyView.isHidden = true
                
                self.dataDidChange()
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib.init(nibName: "LoadMoreCell", bundle: Bundle.main), forCellReuseIdentifier: "loadMoreCell")
        self.tableView.register(UINib.init(nibName: BaseTableViewController.CELL_ID_EMPTY_VIEW, bundle: Bundle.main), forCellReuseIdentifier: BaseTableViewController.CELL_ID_EMPTY_VIEW)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.didRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        
        //To remove extra saparator line
        self.tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @objc open func didRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = self.tableView(tableView, numberOfDataInSection: section)
        let hasMoreData = loadMoreHelper.hasMoreData(section: section)
        count += hasMoreData ? 1 : 0
        return count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.tableView(tableView, cellTypeForRowAt: indexPath)
        if cellType == BaseTableViewController.CELL_TYPE_LOAD_MORE {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath)
            if !loadMoreHelper.isLoading(section: indexPath.section) {
                let data = self.loadMoreHelper.loadData(section: indexPath.section)
                DispatchQueue.main.async {
                    self.tableView(tableView, willLoadMoreData: indexPath.section, with: data)
                }
            }
            return cell
        } else {
            if self.tableView(tableView, numberOfRowsInSection: indexPath.section) - indexPath.row < self.preloadMoreAhead, loadMoreHelper.hasMoreData(section: indexPath.section), !loadMoreHelper.isLoading(section: indexPath.section) {
                let data = self.loadMoreHelper.loadData(section: indexPath.section)
                DispatchQueue.main.async {
                    self.tableView(tableView, willLoadMoreData: indexPath.section, with: data)
                }
            }
            return self.tableView(tableView, cellForDataAt: self.getDataPosition(indexPath: indexPath), with: indexPath)
        }
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var cellHeights = self.cachedCellHeights[indexPath.section] ?? [CGFloat?](repeating: nil, count: self.tableView(tableView, numberOfRowsInSection: indexPath.section))
        if indexPath.row < cellHeights.count {
            cellHeights[indexPath.row] = cell.frame.size.height
        }
        self.cachedCellHeights[indexPath.section] = cellHeights
    }
    
    override open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeights = self.cachedCellHeights[indexPath.section], indexPath.row < cellHeights.count, let height = cellHeights[indexPath.row] {
            return height
        }
        return UITableView.automaticDimension
    }
    
    func getDataPosition(indexPath: IndexPath) -> Int {
        return indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellTypeForRowAt indexPath: IndexPath) -> Int {
        let hasMoreData = loadMoreHelper.hasMoreData(section: indexPath.section)
        if hasMoreData && indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1 {
            return BaseTableViewController.CELL_TYPE_LOAD_MORE
        } else {
            return self.tableView(_:tableView, cellTypeForDataAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellTypeForDataAt indexPath: IndexPath) -> Int {
        return BaseTableViewController.CELL_TYPE_DATA
    }
    
    func tableView(_ tableView: UITableView, cellForHeaderAt headerPosition: Int, with indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    
    open func tableView(_ tableView: UITableView, cellForDataAt dataPosition: Int, with indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfDataInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    open func tableView(_ tableView: UITableView, willLoadMoreData section: Int, with bundle: [String: Any]?) {
        
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = self.tableView(tableView, cellTypeForRowAt: indexPath)
        if cellType != BaseTableViewController.CELL_TYPE_LOAD_MORE {
            self.tableView(tableView, didSelectDataAt: self.getDataPosition(indexPath: indexPath), with: indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectDataAt dataPosition: Int, with indexPath: IndexPath) {
        
    }
    
    open func reloadSection(section: Int) {
        self.reloadSection(section: section, hasMoreData: loadMoreHelper.hasMoreData(section: section), moreDataBundle: loadMoreHelper.loadData(section: section))
    }
    
    open func reloadSection(section: Int, hasMoreData: Bool, moreDataBundle: [String: Any]?) {
        self.cachedCellHeights[section] = [CGFloat?](repeating: nil, count: self.tableView(tableView, numberOfRowsInSection: section))
        loadMoreHelper.updateLoadMoreRecord(section: section, hasMoreData: hasMoreData, loadMoreBundle: moreDataBundle)

        UIView.performWithoutAnimation({
            self.tableView.reloadSections([section], with: .none)
            
            self.dataDidChange()
        })
    }
    
    private func dataDidChange() {
        if let emptyView = self.emptyView {
            let numberOfSections = self.numberOfSections(in: tableView)
            var hasData = false
            for i in 0 ..< numberOfSections {
                if self.tableView(tableView, numberOfRowsInSection: i) > 0 {
                    hasData = true
                    break
                }
            }
            emptyView.isHidden = hasData
        }
    }
    
    func clearCachedHeights() {
        self.cachedCellHeights.removeAll()
    }
    
    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        for indexPath in indexPaths {
            if var cache = self.cachedCellHeights[indexPath.section] {
                if indexPath.row <= cache.count {
                    cache.insert(nil, at: indexPath.row)
                }
                self.cachedCellHeights[indexPath.section] = cache
            }
        }
        self.tableView.insertRows(at: indexPaths, with: animation)
    }
    
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        for indexPath in indexPaths {
            if var cache = self.cachedCellHeights[indexPath.section] {
                if indexPath.row < cache.count {
                    cache.remove(at: indexPath.row)
                }
                self.cachedCellHeights[indexPath.section] = cache
            }
        }
        self.tableView.deleteRows(at: indexPaths, with: animation)
    }
    
    public func reloadRows(at indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else {
            return
        }
        for indexPath in indexPaths {
            if var cache = self.cachedCellHeights[indexPath.section] {
                if indexPath.row < cache.count {
                    cache[indexPath.row] = nil
                }
                self.cachedCellHeights[indexPath.section] = cache
            }
        }
        self.tableView.reloadRows(at: indexPaths, with: .automatic)
//        if self.isScrolling {
//            self.pendingReloadRows += indexPaths
//        } else {
//            UIView.performWithoutAnimation {
//                [ weak self ] in
//                self?.tableView.reloadRows(at: indexPaths, with: .none)
//            }
//        }
    }
    
    private var lastContentOffset: CGFloat = 0
    private var hasDeterminedScrollDirection = false
    
    override open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
        self.lastContentOffset = scrollView.contentOffset.y
        self.hasDeterminedScrollDirection = false
    }
    
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.hasDeterminedScrollDirection {
            self.self.hasDeterminedScrollDirection = true
            if scrollView.contentOffset.y - self.lastContentOffset > 0 {
                // down
                self.scrollDelegate?.scrollViewDidScrollDown()
            } else {
                // up
                self.scrollDelegate?.scrollViewDidScrollUp()
            }
        }
    }
    
    override open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.isScrolling = false
        }
    }
    
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isScrolling = false
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Must be overrided
    
}

extension BaseTableViewController: LoadAdTaskDelegate {
    public func adDidLoad(adTask: LoadAdTask) {
        DispatchQueue.main.async {
            if let cell = adTask.adContainer, cell.adTask == adTask, let indexPath = self.tableView.indexPath(for: cell) {
                self.reloadRows(at: [ indexPath ])
            }
        }
    }
}

public protocol BaseTableViewControllerScrollDelegate: class {
    func scrollViewDidScrollUp()
    func scrollViewDidScrollDown()
}
