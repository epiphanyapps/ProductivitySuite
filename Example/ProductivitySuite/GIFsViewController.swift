//
//  GIFsViewController.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 4/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit
import CoreData
import ProductivitySuite
import Haneke

class GIFsViewController: UIViewController, IGListAdapterDataSource, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<GIF>?
    
    @IBOutlet weak var collectionView: IGListCollectionView!
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }

    func configureView() {
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            fetchedResultsController?.delegate = self
        } catch (let error) {
            print(error)
        }
        
        
//        let wipe = UIBarButtonItem(title: "Wipe",
//                                   style: .plain,
//                                   target: self,
//                                   action: #selector(GIFsViewController.wipeData))
        let random = UIBarButtonItem(barButtonSystemItem: .refresh,
                                     target: self,
                                     action: #selector(GIFsViewController.fetchRandomAmount))
        navigationItem.rightBarButtonItems = [random]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRandomAmount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchRandomAmount() {
        ///http://stackoverflow.com/questions/24132399/how-does-one-make-random-number-between-range-for-arc4random-uniform
        let random = arc4random_uniform(41) + 10;
        
        GIF.fetchGIFs(limit: Int(random)) { (success) in
            print("GIF FETCH \(success)")
        }
    }
    
    func wipeData() {
        let cache = Shared.dataCache
        cache.removeAll()
    }
    
    //MARK: IGListAdapterDataSource
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        
        
        return fetchedResultsController?.fetchedObjects ?? [IGListDiffable]()
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        
        return GIFSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }

    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        adapter.performUpdates(animated: true, completion: nil)
    }
}
