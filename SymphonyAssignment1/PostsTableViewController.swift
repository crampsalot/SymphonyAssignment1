//
//  PostsTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/23/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    let cellID = "PostCell"
    
    var user: UAPUser?
    var allPosts: [UAPPost] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let userId = user?.id else {
            return
        }
        
        UsersAndPostsService.sharedInstance.getPosts(forUserId: userId) { (posts, errorString) in
            if let errorString = errorString {
                DispatchQueue.main.async {
                    print(errorString)
                }
                
                return
            }
            
            if let posts = posts {
                print("Posts count: \(posts.count)")
                self.allPosts = posts
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
        return allPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        let onePost = allPosts[indexPath.row]
        
        // Title
        if let label = cell.viewWithTag(1) as? UILabel, let title = onePost.title {
            label.text = title
        }
        
        // Body
        if let textView = cell.viewWithTag(2) as? UITextView, let body = onePost.body {
            textView.text = body
        }
        
        return cell
    }
}
