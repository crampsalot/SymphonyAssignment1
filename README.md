# SymphonyAssignment1

Users and Posts

For this assignment, you will be writing a simple iOS app using Objective-C/Swift to do the following:

1. Display a scrollable list of users with their name, username, email and phone.
2. On selecting a user, your app should display all the posts for that user with the title and body.
3. You can choose to display it however you wish. A UITableView will be the easiest to do. 
4. You can choose to display any image (randomized) for each user if you like.

Here are the 2 APIs you’ll need: 
 - https://jsonplaceholder.typicode.com/users 
 - https://jsonplaceholder.typicode.com/posts?userId=USER_ID
 
Persistence of data is not needed for this exercise.

Files:

UsersAndPostsService.swift 
 - Singleton class for fetching users, posts, images

UsersTableViewController.swift 
 - view for list of users.

PostsTableViewController.swift 
 - view for list of posts for a given user.

BusyLoading/BusyLoadingView.xib 
 - UI file for "Loading..." view

BusyLoading/BusyLoadingView.swift 
 - UIView class for "Loading ..." view

BusyLoading/BusyLoadingTableViewController.swift 
 - Custom tableview controller containing built in "Loading ..." 
   label and activity indicator as background view.

Image web API URL used:
  - https://api.adorable.io/avatars/SOME_SIZE/SOME_NAME.png
Example: https://api.adorable.io/avatars/80/johndoe.png
