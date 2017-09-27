//
//  localizationManager.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa

class LocalizationManager: NSObject {
    
    // array of supported platforms
    let platforms : [LocalizationPlatform] = [IOSPlatform(), AndroidPlatform()]

    //               lang      plat.    loc.str
    var languages : [String : [String : String]] = [:]

    // newline character used in translation files.
    let newline = "\n"
    
    // ordered array of languages
    var supportedLanguages : [String] = []
    
    /// Add a supported language to the localization manager. Use this before
    /// adding strings
    ///
    /// - Parameter language: language code for which to add support.
    func addLanguage(_ language:String) {
        supportedLanguages.append(language)
        languages[language] = [:]
        
        for platform in platforms {
            languages[language]?[platform.platformKey] = platform.startString
        }
        
    }
    
    
    /// Add a string in a specific language to the localization manager
    ///
    /// - Parameters:
    ///   - value: translated string
    ///   - key: key for the string
    ///   - language: language of the string
    func addString(_ value : String, key: String, language:String) {
        for platform in platforms {
            if var langStr = languages[language]?[platform.platformKey] {
                langStr += String(format:platform.keyValueFormat, key, value) + newline
                languages[language]?[platform.platformKey] = langStr
            }

        }
    }
    
    
    /// Add a comment to the translation tables. This string will not be
    /// translated
    ///
    /// - Parameter comment: comment to add to all translated files.
    func addComment(_ comment : String) {
        for language in supportedLanguages {
            for platform in platforms {
                if var langStr = languages[language]?[platform.platformKey] {
                    langStr += String(format:platform.commentFormat, comment) + newline
                    languages[language]?[platform.platformKey] = langStr
                }
            }
        }
    }
    
    
    /// Add a new line to all translation tables
    func addNewline() {
        for language in supportedLanguages {
            for platform in platforms {
                if var langStr = languages[language]?[platform.platformKey] {
                    langStr += newline
                    languages[language]?[platform.platformKey] = langStr
                }
            }
        }
    }
    
    
    /// End all translation tables
    func end() {
        for language in supportedLanguages {
            for platform in platforms {
                if var langStr = languages[language]?[platform.platformKey] {
                    langStr += platform.endString
                    languages[language]?[platform.platformKey] = langStr
                }
            }
        }
    }

    
    /// Retrieve all strings for a specific platform and language
    ///
    /// - Parameters:
    ///   - platformKey: platform for which to obtain a complete string table
    ///   - language: language for which to obtain a complete string table
    /// - Returns: translation table meeting the specified arguments
    func allStringsFor(platformKey:String, language:String) -> String?{
        return languages[language]?[platformKey]
    }
    
    
    /// Write the strings table to a file. The filename will be prefixed with
    /// the language code of each language supported - multiple files may
    /// be generated depending on the list of supported languages
    ///
    /// - Parameters:
    ///   - platformKey: key of the platform for which we are generating a file
    ///   - path: path name of non-prefixed file. All output files will be
    ///           prefixed with their language code
    func writeOutStringsFor(platformKey:String, path: String) {
        
        for language in localizationManager.supportedLanguages {
            var url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
            let filename = language + "." + url.lastPathComponent
            url = url.deletingLastPathComponent().appendingPathComponent(filename)
            
            try? FileManager.default.removeItem(at: url)
            
            do {
                try localizationManager.allStringsFor(platformKey: platformKey, language: language)?.write(to: url, atomically: true, encoding: String.Encoding.utf8)
                print("Wrote \(platformKey) localizable strings file at \(url.path)")
            }
            catch {
                print("Error writing \(platformKey) localized file")
                exit(EX_USAGE)
            }
        }
    }
}
