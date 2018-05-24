//
//  PostsTableViewController.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/23/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

// View for list of posts for a given user

class PostsTableViewController: BusyLoadingTableViewController {
    private let postsCellID = "PostCell"
    private var allPosts: [UAPPost] = []
    
    var user: UAPUser?

    //MARK: - UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userId = user?.id else {
            return
        }
        
        // If the posts were dynamic then this should be called as
        // a result of some action/trigger
        loadPosts(userId: userId)
    }
    

    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (allPosts.count == 0) {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
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
    
    //MARK: - Utility methods
    // Start loading posts for userId
    private func loadPosts(userId: Int) {
        showBusyLoading()

        UsersAndPostsService.sharedInstance.getPosts(forUserId: userId) { (posts, errorString) in
            
            DispatchQueue.main.async {
                self.hideBusyLoading()
            }

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
    
    //MARK: - TODO
    // variable height rows for posts
}
