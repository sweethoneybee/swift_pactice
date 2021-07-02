//
//  User+CoreDataProperties.swift
//  
//
//  Created by 정성훈 on 2021/07/02.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var profileImageUrl: String?

}
