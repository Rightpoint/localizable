//
//  AndroidPlatform.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa


/// Protocol to implement for localization platforms. This protocol allows
/// classes to return all information required to produce a localized string
/// table for a specific platform
protocol LocalizationPlatform {
    
    /// Unique key used to represent the platform.
    var platformKey : String {get}
    
    /// prefix used to start a localized string table
    var startString : String {get}
    
    /// suffix used to end a localized string table
    var endString : String {get}
    
    /// format used when outputting a string and its key
    var keyValueFormat : String {get}
    
    /// format used when outputting a comment
    var commentFormat : String {get}
    
    // command line parameters
    /// short flag used on the command line to specify this platform
    var shortFlag : String {get}

    /// short flag used on the command line to specify this platform
    var longFlag : String {get}
    
}
