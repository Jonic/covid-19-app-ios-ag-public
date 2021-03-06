//
// Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElementQuery {
    
    subscript(localized key: StringLocalizationKey) -> XCUIElement {
        elementWithText(localize(key))
    }
    
    subscript(localized key: StringLocalizationKey) -> [XCUIElement] {
        localizeAndSplit(key).map { self[verbatim: $0] }
    }
    
    subscript(localized key: ParameterisedStringLocalizable) -> XCUIElement {
        elementWithText(localize(key))
    }
    
    subscript(verbatim string: String) -> XCUIElement {
        elementWithText(string)
    }
    
    subscript<T: RawRepresentable>(key key: T) -> XCUIElement where T.RawValue == String {
        elementWithText(key.rawValue)
    }
    
    private func elementWithText(_ string: String) -> XCUIElement {
        // The API says it has a maximum limit of 128 "characters"; but it actually seems to be checking something like
        // `NSString.length`. This causes the calculation to be incorrect, specially for some non-Latin scripts.
        if string.utf16.count < 128 {
            return self[string]
        } else {
            // XCUITest can not correctly match long labels.
            return element(matching: NSPredicate(format: "label BEGINSWITH %@", String(string.prefix(80))))
        }
    }
    
}

extension Collection where Element == XCUIElement {
    var allExist: Bool {
        return reduce(!isEmpty) { $0 && $1.exists }
    }
}
