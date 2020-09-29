//
//  UserDTO.swift
//  ApiVkEx
//
//  Created by Егор on 20.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import UIKit

struct UserDTO {
    
    var id: Int
    var firstName: String
    var lastName: String
    var online: Int
    var avatar: Data?
    var avatarLink: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case online
        case aviLink = "photo_100"
    }
    
    init?(_ dict: [String: Any]) {
        
        guard
           let id = dict["id"] as? Int,
           let firstName = dict ["first_name"] as? String,
           let lastName = dict["last_name"] as? String,
           let online = dict["online"] as? Int,
           let avatarLink = dict["photo_100"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.online = online
        self.avatarLink = avatarLink
        
        guard let avatarUrl = URL(string: avatarLink) else {return}
        self.avatar = try? Data(contentsOf: avatarUrl)
    }
    
    var avatarImage: UIImage? {
        guard let avi = self.avatar else { return nil}
        return UIImage(data: avi)
    }
    
    var onlineDescription: String {
        return self.online == 1 ? "Online" : "Offline"
    }
}
