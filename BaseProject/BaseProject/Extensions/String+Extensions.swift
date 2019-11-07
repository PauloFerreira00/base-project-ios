//
//  String+Extensions.swift
//  App
//

import Foundation
import UIKit
//swiftlint:disable all
extension String {

    var trim: String {
        get {
            return self.trimmingCharacters(in: .whitespaces)
        }
    }

    static var empty: String {
        return String()
    }

    func replaceCharacter(with value:String) -> String {
        return self.replacingOccurrences(of: "%e", with: value) 
    }

    func localize(isAccessibilty: Bool = false) -> String {

        return NSLocalizedString(self, tableName: isAccessibilty ? "LocalizableAccessibility" : "Localizable", bundle: Bundle.main, value: "", comment: "")

    }

    func getAttributedString(with font: UIFont) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self,
                                         attributes: [NSAttributedString.Key.font: font])
    }

    //call
    func extractAll(type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingResult] {
        var result = [NSTextCheckingResult]()
        do {
            let detector = try NSDataDetector(types: type.rawValue)
            result = detector.matches(in: self, range: NSRange(startIndex..., in: self))
        } catch { print("ERROR: \(error)") }
        return result
    }

    func to(type: NSTextCheckingResult.CheckingType) -> String? {
        let phones = extractAll(type: type).compactMap { $0.phoneNumber }
        switch phones.count {
        case 0: return nil
        case 1: return phones.first
        default: print("ERROR: Detected several phone numbers"); return nil
        }
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

}

extension String {

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[(start ..< end)])
    }

    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        }
    }
}

// MARK: - NSAttributedString extensions
public extension String {

    /// Regular string.
    var regular: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)])
    }

    /// Bold string.
    var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }

    /// Underlined string
    var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    /// Strikethrough string.
    var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }

    /// Italic string.
    var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }

    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
}

extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

