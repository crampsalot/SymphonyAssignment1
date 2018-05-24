//
//  UsersTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    private let cellID = "UserCell"
    private let SEGUE_SHOW_POSTS = "ShowPosts"
    
    private var allUsers: [UAPUser] = []
    private var rowPressed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUsers()
    }
    
    // Start loading users
    private func loadUsers() {
        UsersAndPostsService.sharedInstance.getUsers { (users, errorString) in
            if let errorString = errorString {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message:
                            "Failed to obtain users: \(errorString)", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                return
            }
            
            if let users = users {
                print("Users count: \(users.count)")
                self.allUsers = users
                DispatchQueue.main.async { [unowned self] in
                    // Update tableview with list of users
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneUser = allUsers[indexPath.row]
        
        if let name = oneUser.name {
            print("User \(name) selected")
        }
        
        rowPressed = indexPath.row
        
        performSegue(withIdentifier: SEGUE_SHOW_POSTS, sender: self)
    }
    
    //MARK: - Segue prep
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case SEGUE_SHOW_POSTS:
            if let vc = segue.destination as? PostsTableViewController {
                let oneUser = allUsers[rowPressed]
                // Set the user to get posts for in PostsTableViewController
                vc.user = oneUser
            }
            
        default:
            print("Unknown segue")
        }
    }
}
