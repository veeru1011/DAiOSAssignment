//
//  ViewController.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 16/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate,UIScrollViewDelegate {
    
    //For Pagination
    var isDataLoading: Bool = false
    var pageNo:Int = 0
    var didEndReached: Bool = false
    
    lazy var bottomIndicator: UIActivityIndicatorView =  {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = #colorLiteral(red: 1, green: 0, blue: 0.5, alpha: 1)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.bounds.width, height: CGFloat(44))
        return spinner
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
        
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var dataSource: TableDataSource = {
        return TableDataSource()
    }()
    
    // MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
        loadApiData()
        
    }
    
    //  Handle Pull to refresh method
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.pageNo = 0
        self.didEndReached = false
        self.dataSource.items.removeAll()
        self.loadApiData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helpers
    func setUpTableview() {
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.01))
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userCell")
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        tableView.addSubview(self.refreshControl)
    }
    
    func loadApiData() {
        
        APIManager.shared().getUserList(pageNo: self.pageNo) { (success, result) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.bottomIndicator.stopAnimating()
            }
            switch success {
            case true :
                if let list = result {
                    if let users = list.userList?.users {
                        
                        if users.count == 0 {
                            if let hasMore = list.userList?.has_more {
                                if hasMore == false {
                                    self.isDataLoading = false
                                    self.pageNo =  self.pageNo - 1
                                    self.didEndReached = true
                                }
                            }
                        }
                        else {
                            self.dataSource.items.append(contentsOf: users)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                if (self.refreshControl.isRefreshing) {
                                    self.refreshControl.endRefreshing()
                                }
                            }
                            
                        }
                    }
                }
            case false:
                print(result.debugDescription)
                
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !didEndReached {
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isDataLoading {
                    
                    self.bottomIndicator.startAnimating()
                    self.tableView.tableFooterView = bottomIndicator
                    self.tableView.tableFooterView?.isHidden = false
                    
                    isDataLoading = true
                    self.pageNo =  self.pageNo+1
                    loadApiData()
                }
            }
        }
    }
}



