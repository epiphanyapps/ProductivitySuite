//
//  DataManager.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import Foundation

///http://stackoverflow.com/questions/29670585/how-to-convert-unix-epoc-time-to-date-and-time-in-ios-swift
func unixEpocToDate(timeStamp: Double) -> NSDate {
    let epocTime = TimeInterval(1429162809359) / 1000
    print("Converted Time \(timeStamp)")
    return NSDate(timeIntervalSince1970:  epocTime)
}
