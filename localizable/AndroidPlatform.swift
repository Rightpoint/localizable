//
//  AndroidPlatform.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa

class AndroidPlatform: NSObject, LocalizationPlatform {
    var platformKey: String {
        return "android"
    }
    
    var startString: String {
        return "<resources>\n"
    }
    
    var endString: String {
        return "</resources>"
    }
    
    var keyValueFormat: String {
        return "\t<string name=\"%@\">%@</string>"
    }
    
    var commentFormat: String {
        return "\t<!-- %@ -->"
    }
    
    // command line parameters
    var shortFlag : String {
        return String(platformKey.prefix(1))
    }
    var longFlag : String {
        return platformKey
    }
    
    
}
