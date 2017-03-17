//
//  DataManager.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import UIKit
///http://stackoverflow.com/questions/29670585/how-to-convert-unix-epoc-time-to-date-and-time-in-ios-swift
func unixEpocToDate(timeStamp: Double) -> NSDate {
    let epocTime = TimeInterval(timeStamp) / 1000
    return NSDate(timeIntervalSince1970:  epocTime)
}
