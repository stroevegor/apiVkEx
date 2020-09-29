//
//  PostResponse.swift
//  ApiVkEx
//
//  Created by Егор on 22.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import UIKit

struct PostResponse: Codable {
    let response: Response
}


struct Response: Codable {
    
    private var count: Int = 0
    private var items: [Item] = []
    private var profiles: [Profile] = []
    
    var posts: [PostDTO] {
    
        var posts = [PostDTO]()
        
        for item in items {
    
            let profile = self.profiles.first{ $0.id == item.ownerID}
            
            let text = item.text
            let likes = item.likes.count
            let comments = item.comments.count
            let reposts = item.reposts.count
            let date = Date( Int64(item.date))
            let imageLink = item.photos.first?.photo?.sizes.first?.url
            let owner = (profile?.firstName ?? "") + (profile?.lastName ?? "")
            let ownerImageLink = profile?.avatarLink
            
            
            let post = PostDTO(text: text, likes: likes, comments: comments, reposts: reposts, date: date, imageLink: imageLink, owner: owner, ownerImageLink: ownerImageLink)
    
            posts.append(post)
        }
    
        return posts
    }
    
}

struct Item: Codable {
    var text: String
    var id: Int
    var comments: Count
    var ownerID: Int
    var likes: Count
    var reposts: Count
    var date: Int64
    var photos: [Attachment]
    
    enum CodingKeys: String, CodingKey {
        
        case text
        case id
        case comments
        case ownerID = "owner_id"
        case likes
        case reposts
        case date
        case photos = "attachments"
    }
   
}

struct Attachment: Codable {
    var photo: Photo?
}

struct Photo: Codable {
    var sizes: [PhotoSize]
}

struct PhotoSize: Codable {
    
    var url: String
}

struct Count: Codable  {
    var count: Int
}


struct Profile: Codable {
     var id: Int
     var firstName: String
     var lastName: String
     var avatarLink: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarLink = "photo_50"
    }
}



