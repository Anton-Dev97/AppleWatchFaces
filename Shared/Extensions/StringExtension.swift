//
//  StringExtension.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 12/18/16.
//  Copyright © 2016 Mike Hill. All rights reserved.
//


import UIKit
import Foundation

extension String {
    
    static func random(_ length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
}
