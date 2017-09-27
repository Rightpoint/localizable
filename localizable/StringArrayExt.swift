//
//  StringArrayExt.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa

extension BidirectionalCollection where
    Iterator.Element == String {
    
    
    /// Number non-empty strings in this array
    ///
    /// - Returns: count of non-empty strings in this array
    func filledCount() -> Int {
        let filledColCount = self.filter({ (val) -> Bool in
                return val.characters.count > 0
            }).count
        return filledColCount
    }
}
