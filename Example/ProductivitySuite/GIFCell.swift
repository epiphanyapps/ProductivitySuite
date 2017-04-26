//
//  GIFCell.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 4/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Gifu
import Haneke
import ProductivitySuite

class GIFCell: UICollectionViewCell {
    static let identifier = "GIFCell"
    static let height: CGFloat = 200
    
    @IBOutlet weak var imageView: GIFImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()
    }

    //MARK: - Will test this func using UITests like FBSnapShots

    func configure( gif: GIF) {
        
        textLabel.text = gif.url
        
        let cache = Shared.dataCache
        let url = URL(string: gif.gifURL)!
        imageView.image = #imageLiteral(resourceName: "placeholder")
        cache.fetch(URL: url).onSuccess { [weak self] gifData  in
            self?.imageView.animate(withGIFData: gifData)
        }

    }
}
