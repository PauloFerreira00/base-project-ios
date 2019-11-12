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


public extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        let nib = UINib(nibName: cell.identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cell.identifier)
    }

    func register(nibName: String, identifier: String? = nil) {
        let nib = UINib(nibName: nibName, bundle: nil)
        if let identifier = identifier {
            register(nib, forCellReuseIdentifier: identifier)
        } else {
            register(nib, forCellReuseIdentifier: nibName)
        }
    }

    func registerHeaderFooter(_ reusableView: UITableViewHeaderFooterView.Type) {
        let nib = UINib(nibName: reusableView.identifier, bundle: nil)

        register(nib, forHeaderFooterViewReuseIdentifier: reusableView.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(of class: T.Type,
                                                 for indexPath: IndexPath,
                                                 configure: @escaping ((T) -> Void) = { _ in }) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        if let typedCell = cell as? T {
            configure(typedCell)
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(of class: T.Type) -> T? {
        let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier)
        if let typedView = view as? T {
            return typedView
        }
        return nil
    }

    func genericDequeueReusableCell(of identifier: String,
                                    for indexPath: IndexPath,
                                    configure: @escaping ((UITableViewCell) -> Void) = { _ in }) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configure(cell)
        return cell
    }

    func setHeightTableHeaderView(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let headerView = self?.tableHeaderView else { return }
            var newFrame = headerView.frame
            newFrame.size.height = height

            UIView.animate(withDuration: 0.1) {
                self?.beginUpdates()
                headerView.frame = newFrame
                self?.endUpdates()
            }
        }
    }

    func setHeightTableFooterView(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let footerView = self?.tableFooterView else { return }
            var newFrame = footerView.frame
            newFrame.size.height = height

            UIView.animate(withDuration: 0.1) {
                self?.beginUpdates()
                footerView.frame = newFrame
                self?.endUpdates()
            }
        }
    }
}


