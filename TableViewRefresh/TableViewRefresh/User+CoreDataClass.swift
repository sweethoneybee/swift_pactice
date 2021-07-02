//
//  User+CoreDataClass.swift
//  
//
//  Created by 정성훈 on 2021/07/02.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    static func fetchAll(context: NSManagedObjectContext) -> [User]? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return try? context.fetch(fetchRequest)
    }
}
