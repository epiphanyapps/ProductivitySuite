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
import Kingfisher

final class UserSectionController: ListSectionController {
    
    private var user: User!
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 75)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: UserCell.identifier, bundle: nil, for: self, at: index) as? UserCell else {
            fatalError()
        }
        cell.nameLabel.text = user.first + " " + user.last
        
        var imageResource: ImageResource?
        if let urlString = user.imageURL, let url = URL(string: urlString) {
              imageResource = ImageResource(downloadURL: url)
        } else {
            imageResource = nil
        }
        
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 55, height: 55))
        //FIX: - corner processor not working if not last in options array (same applies vice versa)
        let cornerProcessor = RoundCornerImageProcessor(cornerRadius: 9)
        
        
        cell.thumbnailImageView.kf.setImage(with: imageResource,
                                            placeholder: #imageLiteral(resourceName: "placeholder"),
                                            options:[.transition(ImageTransition.fade(0.3)), .processor(cornerProcessor), .processor(resizingProcessor)],
                                            progressBlock: nil,
                                            completionHandler: nil)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as! User
    }
    
    override func didSelectItem(at index: Int) {
    }
    
}

