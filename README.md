# Localizable

Swift command line utility to take a CSV input of strings
and output localizable string formats for iOS/macOS and Android.

## Getting Started

Clone the repository (recursively, since we use submodules for CSV and Command Line dependencies) and build the application.

To generate the localizable executable app, run xcodebuild in the root of the project directory (with XCode 9 installed) - this will generate the /build/Release/localizable file.

## Usage
Run the application with no arguments to see the following usage information:
```
Usage: ./localizable [options]
  -c, --csv:
      Path to the csv file.
  -i, --ios:
      Path to the ios localized strings file
  -a, --android:
      Path to the android localized strings file
```

### Prerequisites

XCode 9 or above.

## Expected File Format
The input of this application is a CSV file with
several columns of data. The first column represents keys that
can be referenced in iOS/macOS and Android apps for loading
of localized string resources. The subsequent columns have language codes as
their headers and translated strings as the values in each row.

#### Header Row
The first row of the CSV file should contain "key" as the first column value and
the language code represented by each subsequent column.

#### Comments
Comments can be added by wrapping text in **#** symbols - these comments should
appear on their own line.

#### Blank Lines
Blank lines in your CSV file will be preserved and represented in the output
localized string files.

### Example CSV input

The text below is a snippet of a CSV file that has the required headers
and columns for export of localized data in 2 languages

```
key,en,es
#Welcome Strings#,,
welcome.main_title,Welcome to the App!,Bienvenido a la aplicación!
welcome.question,Where are you going?,¿A dónde vas?

```
The output from the above example can be up to 4 files, if parameters are set to output both
iOS/macOS and Android localized string files.

One file will be output for each language, for each platform.

The Spanish iOS output of the above example would look like this (written to a
	file with an *es* prefix):
```
// Welcome Strings
"welcome.main_title"="Bienvenido a la aplicación!";
"welcome.question"="¿A dónde vas?";
```

The Spanish Android output of the above example would look like this (written to a
	file with an *es* prefix):
```
<resources>
	<!-- Welcome Strings -->
	<string name="welcome.main_title">Bienvenido a la aplicación!</string>
	<string name="welcome.question">¿A dónde vas?</string>
</resources>
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Using CommandLine submodule from https://github.com/pdesantis/CommandLine.git
* Using CSV from https://github.com/yaslab/CSV.swift.git
