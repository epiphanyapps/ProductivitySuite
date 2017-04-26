//
//  GIF+CoreDataClass.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 4/11/17.
//
//

import Foundation
import CoreData
import Alamofire
import IGListKit

@objc(GIF)
public class GIF: NSManagedObject, IGListDiffable {
    //MARK: - will write tests for testing dateFormatter
    public static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()
    
    public static func fetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<GIF> {
        
        let gifFetchRequest: NSFetchRequest<GIF> = GIF.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "trendingDatetime", ascending: false)
        gifFetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: gifFetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        return frc

    }
    
    //MARK: - will write tests for FETCH GIF
    public static func fetchGIFs(limit: Int, completion: ((_ success: Bool) -> Void)? ) {
        
        Alamofire.request(GiphyTrendingRouter.trending(limit: limit))
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    guard let response = value as? [String: Any],
                        let gifs = response["data"] as? [[String: Any]] else {
                            return
                    }
                    
                    let context = SharedDataManager.newWorkerContext()
                    
                    context.performAndWait {
                        
                        gifs.forEach({ (gif) in
                            do {
                                let _ = try GIF(data: gif, insertIntoManagedObjectContext: context)
                            } catch (let error) {
                                print(error)
                                DispatchQueue.main.async {
                                    completion?(false)
                                }
                            }
                            
                            
                        })
                        
                        do {
                            try context.save()
                            DispatchQueue.main.async {
                                completion?(true)
                            }
                        } catch (let error) {
                            print(error)
                            DispatchQueue.main.async {
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
        guard let slug = data["slug"] as? String else {
            throw SerializationError.missing("slug")
        }
        
        guard let url = data["url"] as? String else {
            throw SerializationError.missing("text")
        }
        
        guard let trendingDateString = data["trending_datetime"] as? String else {
            throw SerializationError.missing("trending_datetime")
        }
        
        guard let images = data["images"] as? [String: Any],
            let fixedHeightGIF = images["fixed_height"] as? [String: Any],
            let gifURL = fixedHeightGIF["url"] as? String else {
                throw SerializationError.missing("gif url")
        }
        
        
        let entity = NSEntityDescription.entity(forEntityName: "GIF", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.identifier = id
        self.url = url
        self.slug = slug
        self.trendingDatetime = GIF.dateFormatter.date(from: trendingDateString)
        self.gifURL = gifURL
    }
    
    //MARK: - IGListDiffable
    //MARK: - will write tests for diffIdentifier

    public func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return object?.diffIdentifier() == identifier as NSObjectProtocol as! _OptionalNilComparisonType
    }


    
}

