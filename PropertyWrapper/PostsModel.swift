//
//  PostsModel.swift
//  PropertyWrapper
//
//  Created by Ibrahim Mo Gedami on 1/21/24.
//

import Foundation

struct Post: Codable {
    
    let userId, id: Int?
    let title, body: String?
    
}

struct Keys {
    
    static let userId = "userId"
    static let id = "id"
    static let title = "title"
    static let body = "body"
    static let jsonPosts = "jsonPosts"
    static let details = "details"
    
}
