//
//  PostDTO.swift
//  ApiVkEx
//
//  Created by Егор on 21.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation
import UIKit

struct PostDTO: Codable {
    
    var text: String?
    var likes: Int
    var comments: Int
    var reposts: Int
    var date: Date
    var imageLink: String?
    var owner: String?
    var ownerImageLink: String?
    
    
    var ownerAvatarImage: UIImage? {
        
        guard let link = self.ownerImageLink, let avatarUrl = URL(string: link), let avatar = try? Data(contentsOf: avatarUrl) else { return nil }
        
        return UIImage(data: avatar)
    }
    
    var postImage : UIImage? {
           
        guard let link = self.imageLink, let avatarUrl = URL(string: link), let avatar = try? Data(contentsOf: avatarUrl) else {return nil}
           
        return UIImage(data: avatar)
    }
    
    var createDateString : String {
              
        return self.date.adaptiveDateString
    }
}
