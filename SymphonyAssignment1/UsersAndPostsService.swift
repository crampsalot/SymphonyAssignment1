//
//  UsersAndPostsService.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

// Singleton class containing method to fetch from a web service:
// - list of users
// - list of posts for a specific user
// - image for a given user name

/*
 * Sample JSON for one user:
 *
 
 {
 "id": 1,
 "name": "Leanne Graham",
 "username": "Bret",
 "email": "Sincere@april.biz",
 "address": {
 "street": "Kulas Light",
 "suite": "Apt. 556",
 "city": "Gwenborough",
 "zipcode": "92998-3874",
 "geo": {
 "lat": "-37.3159",
 "lng": "81.1496"
 }
 },
 "phone": "1-770-736-8031 x56442",
 "website": "hildegard.org",
 "company": {
 "name": "Romaguera-Crona",
 "catchPhrase": "Multi-layered client-server neural-net",
 "bs": "harness real-time e-markets"
 }
 }
 
 *
 * Sample JSON for one post:
 *
 
 {
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
 }
 
 */

// Data structures to represent JSON elements
// Optionals are used to prevent errors in case any JSON properties
// were missing from REST API eg if "website" was missing from a user JSON.

// Geo data structure - used in address
struct UAPGeo: Decodable {
    let lat: String?
    let lng: String?
}

// Address data structure - used in user
struct UAPAddress: Decodable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: UAPGeo?
}

// Company data structure - used in user
struct UAPCompany: Decodable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

// User data structure
struct UAPUser: Decodable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: UAPAddress?
    let phone: String?
    let website: String?
    let company: UAPCompany?
}

// Post data structure
struct UAPPost: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}

// This singleton class contains 3 methods:
// - getUsers()
// - getPosts()
// - getImage()
//
class UsersAndPostsService {
    // URL constants
    
    private static let USERS_URL_STRING = "https://jsonplaceholder.typicode.com/users"
    
    // POSTS_URL_STRING contains a token that is replaced with a userId.
    // This was done instead of merely appending a userId to a post URL
    // to protect against the case where the URL could grow to contain
    // more parameters and the userId parameter may not be the last one.
    private static let USER_ID_TOKEN = "USER_ID_TOKEN"
    private static let POSTS_URL_STRING = "https://jsonplaceholder.typicode.com/posts?userId=\(USER_ID_TOKEN)"
    
    // IMAGE_URL_STRING contains a token that is replaced with a user name.
    // The '80' in the URL matches the size of the imageView where this
    // image will be used.
    private static let USER_NAME_TOKEN = "USER_NAME_TOKEN"
    private static let IMAGE_URL_STRING = "https://api.adorable.io/avatars/80/USER_NAME_TOKEN.png"
    
    static let sharedInstance = UsersAndPostsService()
    
    // Fetch list of users
    // Results will be in completion handler:
    //   completionHandler(users: [UAPUser]?, errorString)
    func getUsers(completion: ((_ users: [UAPUser]?, _ errorString: String?) -> Void)?) {
        guard let url = URL(string: UsersAndPostsService.USERS_URL_STRING) else {
            completion?(nil, "Error initializing url: " + UsersAndPostsService.USERS_URL_STRING)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(nil, "Response type is not HTTPURLResponse")
                return
            }
            
            guard httpurlResponse.statusCode == 200 else {
                completion?(nil, "HTTP status code is: \(httpurlResponse.statusCode). It should be 200")
                return
            }
            
            guard let data = data else {
                completion?(nil, "Data received back is nil")
                return
            }
            
            do {
                if let users = try self.getUsersFromJSON(jsonData: data) {
                    completion?(users, nil)
                }
            } catch let error as NSError {
                var errorString = "JSON parsing error: \(error)"
                if let jsonDataAsString = String(data: data, encoding: .utf8) {
                    errorString += "\nJSON: " + jsonDataAsString
                }
                
                completion?(nil, errorString)
            }
            
            }.resume()
    }
    
    // Fetch list of posts for a given user ID
    // Results will be in completion handler:
    //   completionHandler(posts: [UAPPost]?, errorString)
    func getPosts(forUserId userId: Int, completion: ((_ posts: [UAPPost]?, _ errorString: String?) -> Void)?) {
        let theURLString = UsersAndPostsService.POSTS_URL_STRING.replacingOccurrences(of: UsersAndPostsService.USER_ID_TOKEN, with: "\(userId)")
        guard let url = URL(string: theURLString) else {
            completion?(nil, "Error initializing url: " + theURLString)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(nil, "Response type is not HTTPURLResponse")
                return
            }
            
            guard httpurlResponse.statusCode == 200 else {
                completion?(nil, "HTTP status code is: \(httpurlResponse.statusCode). It should be 200")
                return
            }
            
            guard let data = data else {
                completion?(nil, "Data received back is nil")
                return
            }
            
            do {
                if let posts = try self.getPostsFromJSON(jsonData: data) {
                    completion?(posts, nil)
                }
            } catch let error as NSError {
                var errorString = "JSON parsing error: \(error)"
                if let jsonDataAsString = String(data: data, encoding: .utf8) {
                    errorString += "\nJSON: " + jsonDataAsString
                }
                
                completion?(nil, errorString)
            }
            
            }.resume()
    }
    
    // Get user image for a given user name
    // Result will be in completion handler:
    //   completionHandler(image: UIImage?, userName: String, errorString)
    // The user name is handed back in the completion handler to help
    // the storing of the image in a cache (eg using it as a key).
    func getImage(forUsername userName: String, completion: ((_ image: UIImage?, _ userName: String, _ errorString: String?) -> Void)?) {
        // Default name in case percent encoding fails
        var percentEncodedUserName = "DefaultUserName"
        
        // Since this userName will be in a URL, make sure it is properly percent
        // encoded
        if let tmpUserName = userName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            percentEncodedUserName = tmpUserName
        }
        
        let theURLString = UsersAndPostsService.IMAGE_URL_STRING.replacingOccurrences(of: UsersAndPostsService.USER_NAME_TOKEN, with: "\(percentEncodedUserName)")
        
        guard let url = URL(string: theURLString) else {
            completion?(nil, userName, "Error initializing url: " + theURLString)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(nil, userName, "Response type is not HTTPURLResponse")
                return
            }
            
            guard httpurlResponse.statusCode == 200 else {
                completion?(nil, userName, "HTTP status code is: \(httpurlResponse.statusCode). It should be 200")
                return
            }
            
            guard let data = data else {
                completion?(nil, userName, "Data received back is nil")
                return
            }
            
            let image = UIImage(data: data)
            completion?(image, userName, nil)
            
            }.resume()
    }
    
    // Extract/decode array of users from data obtained from users service
    private func getUsersFromJSON(jsonData: Data) throws -> [UAPUser]? {
        let users = try JSONDecoder().decode([UAPUser].self, from: jsonData)
        return users
    }
    
    // Extract/decode array of posts from data obtained from posts service
    private func getPostsFromJSON(jsonData: Data) throws -> [UAPPost]? {
        let posts = try JSONDecoder().decode([UAPPost].self, from: jsonData)
        return posts
    }
}
