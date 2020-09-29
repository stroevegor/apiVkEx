//
//  Post+CoreDataProperties.swift
//  ApiVkEx
//
//  Created by Егор on 27.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var imageLink: String?
    @NSManaged public var comments: Int16
    @NSManaged public var date: Date?
    @NSManaged public var likes: Int16
    @NSManaged public var owner: String?
    @NSManaged public var ownerImageLink: String?
    @NSManaged public var reposts: Int16
    @NSManaged public var text: String?

}
