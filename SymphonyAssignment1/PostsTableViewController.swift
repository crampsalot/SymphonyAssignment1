//
//  PostsTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/23/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    private let postsCellID = "PostCell"
    private var allPosts: [UAPPost] = []
    
    var user: UAPUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userId = user?.id else {
            return
        }
        
        loadPosts(userId: userId)
    }
    
    // Start loading posts for userId
    private func loadPosts(userId: Int) {
        UsersAndPostsService.sharedInstance.getPosts(forUserId: userId) { (posts, errorString) in
            
            if let errorString = errorString {
                // Show popup to display error string
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message:
                        "Failed to obtain posts: \(errorString)", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            if let posts = posts {
                print("Posts count: \(posts.count)")
                
                self.allPosts = posts
                DispatchQueue.main.async {
                    if let name = self.user?.name {
                        // Display name of user in title bar
                        self.title = "Posts: \(name)"
                    } else {
                        self.title = "Posts"
                    }
                    
                    // Reload table with list of posts
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (allPosts.count == 0) {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: postsCellID)!
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
