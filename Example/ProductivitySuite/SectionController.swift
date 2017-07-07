//
//  SectionController.swift
//  ProductivitySuite_Example
//
//  Created by Walter Vargas-Pena on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit
import ProductivitySuite

final class UserSectionController: ListSectionController {
    
    private var user: User!
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: UserCell.identifier, bundle: nil, for: self, at: index) as? UserCell else {
            fatalError()
        }
        cell.nameLabel.text = user.first + " " + user.last
        //cell.thumbnailImageView.
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as! User
    }
    
    override func didSelectItem(at index: Int) {
    }
    
}

