//
//  UITableViewCell.swift
//  App
//
//  Created by MacInBox on 09/02/2019.
//  Copyright © 2019 Iteris. All rights reserved.
//
import UIKit

extension UIView {
    static var identifier: String { return String(describing: self) }
}

extension UITableViewCell {

    static var name: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {

    static var name: String {
        return String(describing: self)
    }
}

extension UIStoryboard {

    static var identifier: String {
        return String(describing: self)
    }

    static var name: String {
        return String(describing: self)
    }
}

extension UIViewController {

    static var identifier: String {
        return String(describing: self)
    }

    static var name: String {
        return String(describing: self)
    }
}
