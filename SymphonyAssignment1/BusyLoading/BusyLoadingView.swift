//
//  BusyLoadingView.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/24/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

// View used to display activity indicator and "Loading..." label
class BusyLoadingView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func startWork() {
        activityIndicator.startAnimating()
    }
    
    func endWork() {
        activityIndicator.stopAnimating()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BusyLoadingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
