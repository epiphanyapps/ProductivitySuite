//
//  User+CoreDataProperties.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 7/2/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var dob: Date
    @NSManaged public var identifier: String
    @NSManaged public var first: String
    @NSManaged public var imageURL: String?
    @NSManaged public var last: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var todos: NSSet

}

// MARK: Generated accessors for todos
extension User {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
