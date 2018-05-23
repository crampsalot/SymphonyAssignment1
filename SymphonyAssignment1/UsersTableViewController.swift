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
    
    var allUsers: [UAPUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersAndPostsService.sharedInstance.getUsers { (users, errorString) in
            if let errorString = errorString {
                DispatchQueue.main.async {
                    print(errorString)
                }
                
                return
            }
            
            if let users = users {
                print("Users count: \(users.count)")
                self.allUsers = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        let oneUser = allUsers[indexPath.row]
        
        // Name
        if let label = cell.viewWithTag(1) as? UILabel, let name = oneUser.name {
            label.text = name
        }
        
        // Username
        if let label = cell.viewWithTag(2) as? UILabel, let username = oneUser.username {
            label.text = username
        }
        
        // Email
        if let label = cell.viewWithTag(3) as? UILabel, let email = oneUser.email {
            label.text = email
        }
        
        // Phone
        if let label = cell.viewWithTag(4) as? UILabel, let phone = oneUser.phone {
            label.text = phone
        }
        
        return cell
    }
}
