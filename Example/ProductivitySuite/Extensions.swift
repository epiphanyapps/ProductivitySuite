//
//  Extensions.swift
//  ProductivitySuite_Example
//
//  Created by Walter Vargas-Pena on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol ReusableView {
    
   static var identifier: String { get }
    
}

extension ReusableView {
    
    static var identifier: String {
        return "\(self)"
    }
}

