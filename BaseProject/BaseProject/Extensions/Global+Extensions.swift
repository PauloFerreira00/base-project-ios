//
//  Global+Extensions.swift
//  App
//
//  Created by Iteris Consultoria on 21/05/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation
import UIKit

public protocol Appliable {}

public extension Appliable {
    @discardableResult
    func apply(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

public protocol Runnable {}

public extension Runnable {
    @discardableResult
    func run<T>(closure: (Self) -> T) -> T {
        return closure(self)
    }
}

extension NSObject: Appliable {}
extension NSObject: Runnable {}

extension DateFormatter {
    func formatWith(dateString: String, patternInput: String, patternOutput: String) -> String {
        self.dateFormat = patternInput
        guard let date = self.date(from: dateString) else { return String.empty }
        self.dateFormat = patternOutput
        return self.string(from: date)
    }
}
// swiftlint:disable next force_cast
extension NSOrderedSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

extension UISearchBar {
    func setBackground(color: UIColor) {
        for subView in self.subviews {
            for subView1 in subView.subviews {
                if subView1.isKind(of: UITextField.self) {
                    subView1.backgroundColor = color
                }
            }
        }
    }
}

