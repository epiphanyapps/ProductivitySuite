//
//  Todo+CoreDataClass.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import Foundation
import CoreData
import Alamofire

@objc(Todo)
public class Todo: NSManagedObject {

    public static func fetchTodos(completion: ((_ success: Bool) -> Void)? ) {
    
        Alamofire.request(TodoRouter.getTodoList)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    if let todos = value as? [[String: Any]] {
                        
                        let context = SharedDataManager.newWorkerContext()
                        
                        todos.forEach({ (todo) in
                            context.performAndWait {
                                do {
                                    try Todo(data: todo, insertIntoManagedObjectContext: context)
                                } catch (let error) {
                                    print(error)
                                    completion?(false)
                                }
                            }
                        })
                        
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

        guard let text = data["text"] as? String else {
            throw SerializationError.missing("text")
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
        
        self.id = id
        self.text = text
        self.checked = checked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
