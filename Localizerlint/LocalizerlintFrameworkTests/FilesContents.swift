//
//  FilesContents.swift
//  LocalizerlintFrameworkTests
//
//  Created by Samuel Lagunes on 12/16/20.
//

import Foundation


let localizedStrings = """
/*
  test.strings
  Localizerlint
  Created by Samuel Lagunes on 12/15/20.
*/

/* Coupon Message */
"DISH_NAME_LABEL" = "Name";
"INGREDIENTS_LABEL" = "Ingredients";
"DESCRIPTION_LABEL" = "Description";

/* Coupon Message */
"PRICE_LABEL" = "Price";
"PRICE_LABEL" = "Price";
"""

let localizedCode = """
//Using NSLocalizedString
NSLocalizedString("DESCRIPTION_LABEL", comment: "comment for description")

//Using Bundle
Bundle.main.localizedString(forKey: "DISH_NAME_LABEL", value: "comment for name", table: nil)

//Using SwiftUI
Text("DISH_AVAILABILITY")
"""

let localizedCodeObjectiveC = """
//UsingObjective-C
[NSBundle.mainBundle localizedStringForKey: @"DISH_NAME_INGREDIENTS", value: @"comment for ingredients", table: nil];
NSLocalizedString(@"DISH_ID", @"comment for dish id");
"""
