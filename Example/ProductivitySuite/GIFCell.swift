//
//  GIFCell.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 4/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Gifu

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
        print("prepareForReuse")
    }
    
}
