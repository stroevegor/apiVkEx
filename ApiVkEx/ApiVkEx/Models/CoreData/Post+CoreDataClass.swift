//
//  Post+CoreDataClass.swift
//  ApiVkEx
//
//  Created by Егор on 27.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//
//

import Foundation
import CoreData


public class Post: NSManagedObject {
    
    var dto: PostDTO {
        return PostDTO(text: self.text, likes: Int(self.likes), comments: Int(self.comments), reposts: Int(self.reposts), date: self.date ?? Date(), imageLink: self.imageLink, owner: self.owner, ownerImageLink: self.ownerImageLink)
    }

}
