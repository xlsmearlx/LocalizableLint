## localizerlint

#### This command line tool helps in the search for unused and duplicated localization strings in Xcode projects.

## Usage


	USAGE: localizerlint [<path>] [--search-duplicates-only] [--inclue-swift-ui] [--include-objective-c] [--brute-force] [--strict] [--verbose]

ARGUMENTS	  | Usage
------------|-------------------------------------------------------------
\<path\>    | The root path of the project

>Note: If no **\<path\>** is provided the tool will use the current directory path

Flags                     | Usage
--------------------------|-------------------------------------------------------------
--search-duplicates-only  | Search diplicate keys in Localized Strings files, ignoring any unused keys 
--inclue-swift-ui         | Enables analyzer for Localized Strings in SwiftUI Format 
--include-objective-c     | Enables analyzer for Localized Strings in Objective-C Format 
--brute-force             | Will validate againts all strings 
-s, --strict              | Treats warnings as erros 
-v, --verbose             | Shows details about the results of running Localizerlint 

>Note: **--brute-force** automatically disables **--inclue-swift-ui** and **--include-objective-c**

## Example

##### Find duplicate strings

```
$localizerlint Project_Directory/ --search-duplicates-only

Validating for duplicate keys in file: /SampleApp/Shared/en.lproj/Localizable.strings

/SampleApp/Shared/en.lproj/Localizable.strings:8: error: Found duplicate key: "DISH_NAME_LABEL" in file: /SampleApp/Shared/en.lproj/Localizable.strings

/SampleApp/Shared/en.lproj/Localizable.strings:11: error: Found duplicate key: "DESCRIPTION_LABEL" in file: /SampleApp/Shared/en.lproj/Localizable.strings

```

##### Find unused and duplicate strings

```
$localizerlint Project_Directory/ --search-duplicates-only

Validating for duplicate keys in file: /SampleApp/Shared/en.lproj/Localizable.strings

/SampleApp/Shared/en.lproj/Localizable.strings:8: error: Found duplicate key: "DISH_NAME_LABEL" in file: /SampleApp/Shared/en.lproj/Localizable.strings

/SampleApp/Shared/en.lproj/Localizable.strings:11: error: Found duplicate key: "DESCRIPTION_LABEL" in file: /SampleApp/Shared/en.lproj/Localizable.strings

Validating for duplicate keys in file: /SampleApp/Shared/es-419.lproj/Localizable.strings

KEYS: 3 | DEADKEYS: 0 | /Users/slagunes/Developer/Localizerlint/SampleApp/Shared/en.lproj/Localizable.strings
KEYS: 5 | DEADKEYS: 2 | /Users/slagunes/Developer/Localizerlint/SampleApp/Shared/es-419.lproj/Localizable.strings

Searching for unused keys

/SampleApp/Shared/es-419.lproj/Localizable.strings:13: warning: "PRICE_LABEL" was defines but never used
```

## Default search
##### By default the tool will validate againts the following swift syntaxt.
```
//Using NSLocalizedString
NSLocalizedString("MY_LOCALIZED_KEY", comment: "")

//Using Bundle
Bundle.main.localizedString(forKey: "MY_LOCALIZED_KEY", value: "", table: nil)
```

## Searching in Objective-C

##### By enabling the flag `--include-objective-c` the tool will include all `.m` files in the given path and validate using Objective-C syntax.

```
//Using NSLocalizedString
NSLocalizedString(@"MY_LOCALIZED_KEY", @"");

//Using NSBundle
[NSBundle.mainBundle localizedStringForKey: @"MY_LOCALIZED_KEY", value: @"", table: nil];
```

## Searching in SwiftUI
##### By enabling the flag `--inclue-swift-ui` the tool will validate Texts in SwiftUI syntax.
```
struct ContentView: View {
    var body: some View {
        Text("MY_LOCALIZED_KEY") 
    }
}
```


##### Xcode Integration

This tool is designed to be used as part of Xcode's Build. To integrate it just add a new `run script` phase 

![add_build_phase](readme_files/xcode_build_phase.png)

After the tools is done searching for unused and duplicated keys, Xcode will display the violations.

![xcode_build_log](readme_files/xcode_build_log.png)
