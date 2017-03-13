//
//  Todo+CoreDataClass.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

    func update(dict: [String: Any]) {
        self.checked = dict["checked"] as? Bool ?? false
        self.text = dict["text"] as? String
        self.id = dict["id"] as? String
        
        if let created = dict[""] as? Double {
            self.createdAt = unixEpocToDate(timeStamp: created)
        }
        if let updated = dict[""] as? Double {
            self.updatedAt = unixEpocToDate(timeStamp: updated)
        }
    }
    
}
