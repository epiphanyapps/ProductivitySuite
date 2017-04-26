//
//  GIFSectionController.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 4/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import IGListKit
import Alamofire
import ProductivitySuite

final class GIFSectionController: IGListSectionController, IGListSectionType {
    
    var gif: GIF!
    
    // MARK: IGlistSectionType
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: GIFCell.height)
    }
    
    //MARK: - Will test this func using UITests or FBSnapShots
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let gifCell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: GIFCell.identifier, for: self, at: index) as! GIFCell
        
        gifCell.configure(gif: gif)
        
        return gifCell
    }
    
    func didUpdate(to object: Any) {
        gif = object as? GIF
    }
    
    func didSelectItem(at index: Int) {}
    
    
   // *********************
    //MARK: - I was going to implement working range & display delegate of IGListKIT to pre download but performance worked well. Also performance worked well for start/stop due to prepareForReuse of GIFImageView
   // *********************
    /*
    
    // MARK: IGListDisplayDelegate
    
    
    func listAdapter(_ listAdapter: IGListAdapter, willDisplay sectionController: IGListSectionController) { }
    
    
    func listAdapter(_ listAdapter: IGListAdapter, didEndDisplaying sectionController: IGListSectionController) { }
    
    

    func listAdapter(_ listAdapter: IGListAdapter, willDisplay sectionController: IGListSectionController, cell: UICollectionViewCell, at index: Int) {
        let gifCell = cell as! GIFCell
        gifCell.imageView.startAnimatingGIF()
    }
    
    
    func listAdapter(_ listAdapter: IGListAdapter, didEndDisplaying sectionController: IGListSectionController, cell: UICollectionViewCell, at index: Int) {
        let gifCell = cell as! GIFCell
        gifCell.imageView.stopAnimatingGIF()
    }

    //MARK: IGListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerWillEnterWorkingRange sectionController: IGListSectionController) {
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerDidExitWorkingRange sectionController: IGListSectionController) {}
*/
}

