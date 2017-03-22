//
//  DataManager.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import UIKit
import CoreData

public let SharedDataManager = DataManager.sharedInstance

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

///http://stackoverflow.com/questions/29670585/how-to-convert-unix-epoc-time-to-date-and-time-in-ios-swift
func unixEpocToDate(timeStamp: Double) -> Date {
    let epocTime = TimeInterval(timeStamp) / 1000
    return Date(timeIntervalSince1970:  epocTime)
}

public class DataManager: NSObject {
    
    static var sharedInstance = DataManager()
        
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        let modelURL = bundle.url(forResource: "ProductivitySuite", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ProductivitySuite.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch(let error){
            print("Something went wrong during initialatzion of persistent store. \(error)")
            abort()
        }
        
        return coordinator
    }()
    
    // MARK: - Context management
    
    lazy var rootContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        return moc
    }()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        var moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self.rootContext
        return moc
    }()
    
    public func newWorkerContext() -> NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.managedObjectContext
        return moc
    }
    
    public func saveContext () {
        guard self.managedObjectContext.hasChanges else { return }
        DispatchQueue.main.sync() {
            do { try self.managedObjectContext.save() }
            catch let error as NSError {
                print("Unresolved error while saving main context \(error), \(error.userInfo)")
            }
        }
        self.rootContext.performAndWait {
            do { try self.rootContext.save() }
            catch let error as NSError {
                print("Unresolved error while saving to persistent store \(error), \(error.userInfo)")
            }
        }
    }

}
