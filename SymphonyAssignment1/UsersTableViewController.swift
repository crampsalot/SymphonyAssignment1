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
    let SEGUE_SHOW_POSTS = "ShowPosts"
    
    var allUsers: [UAPUser] = []
    var rowPressed = 0
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneUser = allUsers[indexPath.row]
        
        if let name = oneUser.name {
            print("User \(name) selected")
        }
        
//        if let userId = oneUser.id {
//            UsersAndPostsService.sharedInstance.getPosts(forUserId: userId, completion: { (posts, errorString) in
//                if let errorString = errorString {
//                    DispatchQueue.main.async {
//                        print(errorString)
//                    }
//                    
//                    return
//                }
//                
//                if let posts = posts {
//                    print("Number of posts: \(posts.count)")
//                    print(posts)
//                }
//
//            })
//        }
        
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
                vc.user = oneUser
            }
            
        default:
            print("BLEScanner: Unknown segue")
        }
    }
}
