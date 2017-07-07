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
                            
                            do {
                                
                                users.forEach({ (userDict) in
                                    do {
                                        let aUser = try User.findOrCreate(data: userDict, insertIntoManagedObjectContext: context)
                                        debugPrint(aUser)
                                    } catch let userInitError {
                                        debugPrint(userInitError)
                                    }
                                    
                                })
                                
                                try context.save()
                                completion?(true)
                            } catch (let saveError) {
                                print(saveError)
                                completion?(false)
                            }
                            
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
        
//        guard let checked = data["checked"] as? Bool else {
//            throw SerializationError.missing("checked")
//        }
        
        guard let createdAtDouble = data["createdAt"] as? Double else {
            throw SerializationError.missing("createdAt")
        }
        let createdAt = unixEpocToDate(timeStamp: createdAtDouble)
        
        guard let updatedAtDouble = data["updatedAt"] as? Double else {
            throw SerializationError.missing("updatedAt")
        }
        let updatedAt = unixEpocToDate(timeStamp: updatedAtDouble)
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.identifier = id
        self.first = first
        self.last = last
//        self.checked = checked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    /**
     This method creates and serializes a user object and creates one if none exists.
     - Note: This methods uniques by `id` parameter of type `String` and throws if certain required parameters are missing.
    */
    static func findOrCreate(data: [String: Any], insertIntoManagedObjectContext context: NSManagedObjectContext) throws -> User  {
        
        
        guard let identifier = data["id"] as? String else {
            throw SerializationError.missing("id")
        }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        let results = try! context.fetch(request)
        
        switch results.count {
        case 0:
            let newUser = try! User(data: data, insertIntoManagedObjectContext: context)
            return newUser
        case 1:
            return results.first!
        default:
            fatalError("uniquing is corrupted store")
        }
    }
}
