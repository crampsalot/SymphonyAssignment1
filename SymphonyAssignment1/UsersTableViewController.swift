//
//  UsersTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    let cellID = "UserCell"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        
        // Name
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = "Isa Hashim"
        }
        
        // Username
        if let label = cell.viewWithTag(2) as? UILabel {
            let username = "crampsalot"
            label.text = username
        }
        
        // Email
        if let label = cell.viewWithTag(3) as? UILabel {
            label.text = "isa@crampsalot.com"
        }
        
        // Phone
        if let label = cell.viewWithTag(4) as? UILabel {
            label.text = "408-111-2222"
        }
        
        return cell
    }
}
