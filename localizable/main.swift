//
//  main.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/25/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation

// Localization Manager that produces the platform and language specific strings tables
var localizationManager = LocalizationManager()

// command line manager
let cli = CommandLine()
let csvFile = StringOption(shortFlag: "c", longFlag: "csv", required: true,
                                            helpMessage: "Path to the csv file.")
cli.addOption(csvFile)

// create an array to contain each supported platform.
var outputOptions : [StringOption] = []

for platform in localizationManager.platforms {
    outputOptions.append(StringOption(platform.shortFlag, platform.longFlag, false, "Path to the \(platform.platformKey) localized strings file"))
}
// add each platform to the CLI options.
cli.addOptions(outputOptions)

//
// try to parse incoming command line parameters
//
do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

//
// ensure there were some output files specified
//
let specifiedOutputCount = outputOptions.filter { (option) -> Bool in
    return option.value != nil
}.count

if 0 == specifiedOutputCount {
    print("Either an iOS/macOS or Android localizable file must be specified")
    exit(EX_USAGE)
}

/// character used to delimit comments in the strings CSV input file.
let commentDelimeter = "#"

/// column header used for keys
let keyColumnHeader = "key"

// keep a running count of how many strings we output.
var stringCount = 0
var commentCount = 0

do {
    // we can force unbox this one since it is a requred parameter.
    print("CSV path is \(csvFile.value!)")
    let csvPath = csvFile.value! as NSString
    
    if let inputStream = InputStream(fileAtPath: csvPath.expandingTildeInPath) {

        let csv = try CSV(stream: inputStream, hasHeaderRow: true)

        // add languages from the header row
        if let headerRow = csv.headerRow {
            for language in headerRow {
                if language.characters.count > 0 && language != keyColumnHeader {
                    localizationManager.addLanguage(language)
                    print("Adding support for language \(language)")
                }
            }            
        }
        
        // loop through the remaining rows afer the header
        while let row = csv.next() {
            let filledColCount = row.filledCount()

            // if there are 2 or more columns populated, there are translated values to store
            if filledColCount >= 2 {
                for (langIndex, language) in localizationManager.supportedLanguages.enumerated() {
                    if(filledColCount > langIndex+1) {
                        localizationManager.addString(row[langIndex+1], key: row[0], language: language)
                        print("Adding string:\(row[langIndex+1]) for key:\(row[0]) for language:\(language)")
                    }
                   
                }
                stringCount += 1
            }
                
            // if there is one column filled in, it might be a comment
            else if filledColCount == 1 {
                
                // output the row as a comment if it is surrounded by # indicating
                // it is a comment
                if row[0].hasPrefix(commentDelimeter) && row[0].hasSuffix(commentDelimeter) {
                    let val = row[0].trimmingCharacters(in: CharacterSet(charactersIn:commentDelimeter))
                    localizationManager.addComment(val)
                    commentCount += 1
                }
            }
            else {
                // any other rows should be ignored and result in a new line.
                localizationManager.addNewline()
            }

        }
        
        // end of the localization. End all tables.
        localizationManager.end()
        
    }

} catch {
    print("Error reading CSV File")
    exit(EX_USAGE)
}

print("Writing out \(stringCount) strings and \(commentCount) comments")

// for every option, if a value has been specified, write out a file for
// all languages.
for outputOption in outputOptions {
    if let path = outputOption.value,
        let platformKey = outputOption.longFlag {
        localizationManager.writeOutStringsFor(platformKey: platformKey, path: path)
    }
}
