//
//  GIF+CoreDataProperties.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 4/11/17.
//
//

import Foundation
import CoreData


extension GIF {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GIF> {
        return NSFetchRequest<GIF>(entityName: "GIF")
    }

    @NSManaged public var identifier: String
    @NSManaged public var slug: String
    @NSManaged public var url: String
    @NSManaged public var gifURL: String
    @NSManaged public var trendingDatetime: Date?

}
