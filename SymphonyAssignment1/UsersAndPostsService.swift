//
//  UsersAndPostsService.swift
//  SymphonyAssignment1
//
//  Created by Isa Hashim on 5/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import Foundation

/*
 
 One user:
 
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
 
 One post:
 
 {
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
 }
 
 */

struct UAPGeo: Decodable {
    let lat: String?
    let lng: String?
}

struct UAPAddress: Decodable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: UAPGeo?
}

struct UAPCompany: Decodable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

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

struct UAPPost: Decodable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}

class UsersAndPostsService {
    private let USERS_URL_STRING = "https://jsonplaceholder.typicode.com/users"
    private let USER_ID_TOKEN = "USER_ID_TOKEN"
    private let POSTS_URL_STRING: String

    static let sharedInstance = UsersAndPostsService()
    
    private init() {
        POSTS_URL_STRING = "https://jsonplaceholder.typicode.com/posts?userId=\(USER_ID_TOKEN)"
    }
    
    func getUsers(completion: ((_ users: [UAPUser]?, _ errorString: String?) -> Void)?) {
        guard let url = URL(string: USERS_URL_STRING) else {
            completion?(nil, "Error initializing url: " + USERS_URL_STRING)
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
    
    func getPosts(forUserId userId: Int, completion: ((_ posts: [UAPPost]?, _ errorString: String?) -> Void)?) {
        let theURLString = POSTS_URL_STRING.replacingOccurrences(of: USER_ID_TOKEN, with: "\(userId)")
        print("Getting posts with URL: ", theURLString)
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
    
    private func getUsersFromJSON(jsonData: Data) throws -> [UAPUser]? {
        let users = try JSONDecoder().decode([UAPUser].self, from: jsonData)
        return users
    }
    
    private func getPostsFromJSON(jsonData: Data) throws -> [UAPPost]? {
        let posts = try JSONDecoder().decode([UAPPost].self, from: jsonData)
        return posts
    }
}
