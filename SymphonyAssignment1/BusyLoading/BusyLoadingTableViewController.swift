//
//  BusyLoadingTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/24/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

// Custom tableviewcontroller that has a built in activity indicator
// and label as the backgroundView. This can be displayed when data
// for the cells are being loaded.
class BusyLoadingTableViewController: UITableViewController {
    private var busyLoadingView: BusyLoadingView?
    
    //MARK: - UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBusyLoadingIndicator()
    }
    
    private func initBusyLoadingIndicator() {
        if (busyLoadingView == nil) {
            busyLoadingView = BusyLoadingView()
        }
    }
    
    func showBusyLoading() {
        self.initBusyLoadingIndicator()
        
        tableView.separatorStyle = .none
        tableView.backgroundView = busyLoadingView
        busyLoadingView?.center = tableView.center
        busyLoadingView?.startWork()
    }
    
    func hideBusyLoading() {
        busyLoadingView?.endWork()
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
    }
}

