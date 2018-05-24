//
//  UsersTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

// View controller for list of Users

class UsersTableViewController: BusyLoadingTableViewController {
    private let cellID = "UserCell"
    private let SEGUE_SHOW_POSTS = "ShowPosts"
    
    // Array of users fetched by loadUsers()
    private var allUsers: [UAPUser] = []
    
    // Very simple image cache - images displayed for each user
    // key = userName
    // image fetch done in loadImage()
    // Size of cache not checked, no images are purged
    private var userImagesCache: [String:UIImage?] = [:]
    
    // used to determine which user to pass on to PostsTableViewController
    private var rowPressed = 0
    
    //MARK: - UIView Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch users when view is loaded
        // If we expect the users list to change, then this should be
        // called as a result of some trigger/action or even in
        // viewWillAppear()
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
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
        
        // Image
        if let imageView = cell.viewWithTag(5) as? UIImageView, let username = oneUser.username {
            if let image = userImagesCache[username] {
                imageView.image = image
                imageView.layer.cornerRadius = 8
                imageView.clipsToBounds = true
            } else {
                loadImage(forUserName: username, andIndex: indexPath.row)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    //MARK: - Utility methods
    
    // Start loading users
    private func loadUsers() {
        showBusyLoading()
        
        UsersAndPostsService.sharedInstance.getUsers { (users, errorString) in
            DispatchQueue.main.async {
                self.hideBusyLoading()
            }
            
            if let errorString = errorString {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message:
                        "Failed to obtain users: \(errorString)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            if let users = users {
                // set list of users
                // empty image cache
                self.allUsers = users
                self.userImagesCache = [:]
                DispatchQueue.main.async {
                    // Update tableview with list of users
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Start fetching image for user
    private func loadImage(forUserName userName: String, andIndex userIndex: Int) {
        UsersAndPostsService.sharedInstance.getImage(forUsername: userName, userIndex: userIndex) {
                    (image, userName, userIndex, errorString) in
            if let errorString = errorString {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message:
                        "Failed to image for user \(userName): \(errorString)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                // Successfully got the image
                
                // Store it in cache
                self.userImagesCache[userName] = image
                
                // 'userIndex' passed in is the index/row of the user in the table
                // Use this to refresh just that one row and not the entire
                // table.
                if ((userIndex >= 0) && (userIndex < self.allUsers.count)) {
                    let indexPath = IndexPath(row: userIndex, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }
        }
    }
}
