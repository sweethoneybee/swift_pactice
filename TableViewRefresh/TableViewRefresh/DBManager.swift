//
//  DBManager.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/07/02.
//

import Foundation
import CoreData

class DBManager {
    static let shared: DBManager = DBManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TableViewRefresh")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    @discardableResult
    func insertPerson(person: Person) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: self.context) else { return false }
        guard let count = try? self.context.count(for: User.fetchRequest()) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
        
        managedObject.setValue(ApiProvider.baseUrl + "\(count + 1).jpg", forKey: "profileImageUrl")
        managedObject.setValue("이것은 설명입니다. 길게 적지 않을 꺼야잉", forKey: "desc")
        managedObject.setValue("이름 \(count + 1)", forKey: "name")
        
        do {
            try self.context.save()
            print("insert 성공")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool{
        let request: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
            print("전체 삭제 성공")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
