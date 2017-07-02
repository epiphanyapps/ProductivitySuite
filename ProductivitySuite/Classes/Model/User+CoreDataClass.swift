//
//  User+CoreDataClass.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 7/2/17.
//
//

import Foundation
import CoreData
import Alamofire

@objc(User)
public class User: NSManagedObject {
    
    public static func fetchUsers(completion: ((_ success: Bool) -> Void)? ) {
        
        Alamofire.request(UserRouter.getUserList)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    if let users = value as? [[String: Any]] {
                        
                        let context = SharedDataManager.newWorkerContext()
                        
                        context.perform {
                            
                            for (index, user) in users.enumerated() {
                                do {
//                                    let _ = try User(data: user, insertIntoManagebjectContext: context)
                                    
//                                    if users.index(of: user) == index {
//                                        try context.save()
//
//                                    }
                                } catch (let error) {
                                    print(error)
                                    completion?(false)
                                }
                            }
                            
                        }
                        
                        do {
                            try context.save()
                            completion?(true)
                        } catch (let error) {
                            print(error)
                            completion?(false)
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
    }
    
    convenience init(data: [String: Any], insertIntoManagedObjectContext context: NSManagedObjectContext) throws {
        
        guard let id = data["id"] as? String else {
            throw SerializationError.missing("id")
        }
        
        guard let first = data["first"] as? String else {
            throw SerializationError.missing("first")
        }
        
        guard let last = data["last"] as? String else {
            throw SerializationError.missing("last")
        }
        
        guard let checked = data["checked"] as? Bool else {
            throw SerializationError.missing("checked")
        }
        
        guard let createdAtDouble = data["createdAt"] as? Double else {
            throw SerializationError.missing("createdAt")
        }
        let createdAt = unixEpocToDate(timeStamp: createdAtDouble)
        
        guard let updatedAtDouble = data["updatedAt"] as? Double else {
            throw SerializationError.missing("updatedAt")
        }
        let updatedAt = unixEpocToDate(timeStamp: updatedAtDouble)
        
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.identifier = id
        self.first = first
        self.last = last
        self.checked = checked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
