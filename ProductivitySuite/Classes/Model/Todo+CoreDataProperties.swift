//
//  Todo+CoreDataProperties.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo");
    }

    @NSManaged public var checked: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var text: String?
    @NSManaged public var updatedAt: Date

}
