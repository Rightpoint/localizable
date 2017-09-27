//
//  IOSPlatform
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa

class IOSPlatform: NSObject, LocalizationPlatform {
    var platformKey: String {
        return "ios"
    }
    
    var startString: String {
        return ""
    }
    
    var endString: String {
        return ""
    }
    
    var keyValueFormat: String {
        return "\"%@\"=\"%@\";"
    }
    
    var commentFormat: String {
        return "// %@"
    }
    
    // command line parameters
    var shortFlag : String {
        return String(platformKey.prefix(1))
    }
    var longFlag : String {
        return platformKey
    }
}
