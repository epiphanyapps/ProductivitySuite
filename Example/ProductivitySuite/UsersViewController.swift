//
//  UsersViewController.swift
//  ProductivitySuite_Example
//
//  Created by Walter Vargas-Pena on 7/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit
import ProductivitySuite
import Localize_Swift

class UsersViewController: UIViewController {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    )
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users".localized()
        view.addSubview(collectionView)
        adapter.dataSource = self
        adapter.collectionView = collectionView
        collectionView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "Test", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self,
                                 action: #selector(UsersViewController.updateUsers),
                                 for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func updateUsers() {
        User.fetchUsers { [weak self] (success) in
            self?.refreshControl.endRefreshing()
            guard success else { return }
                
            self?.adapter.performUpdates(animated: true,
                                         completion: nil)
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UsersViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let allUsers =  User.all()
        return allUsers
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return UserSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
