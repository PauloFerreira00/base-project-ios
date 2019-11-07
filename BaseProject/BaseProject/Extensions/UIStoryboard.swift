//
//  UIStoryboard.swift
//  App
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/08/19.
//  Copyright © 2019 Paulo Ferreira de Jesus - PFR. All rights reserved.
//
import UIKit

extension UINib {
    static func instantiateViewController<T: UIViewController>(from nibName: UINib.Name) -> T where T: Identifiable {
        guard let viewController = T.init(nibName: nibName.rawValue, bundle: nil) as? T else {
            fatalError("Could not instantiate ViewController with identifier: \(T.storyboardIdentifier)")
        }
        return viewController
    }

    enum Name: String {
        case start = "StartViewController"
    }
}

extension UIStoryboard {
    /// Creates a view controller from storyboard
    ///
    /// - Parameters:
    ///   - storyboard: storyboard name
    /// - Returns: view controller instance
    static func instantiateViewController<T: UIViewController>(from storyboard: UIStoryboard.Name) -> T where T: Identifiable {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: T.self.storyboardIdentifier) as? T else {
            fatalError("Could not instantiate ViewController with identifier: \(T.storyboardIdentifier)")
        }

        return viewController
    }

    /// Creates a view controller from storyboard with storyboard id
    ///
    /// - Parameters:
    ///   - storyboard: storyboard name
    /// - Returns: view controller instance
    static func instantiateViewController<T: UIViewController>(from storyboard: UIStoryboard.Name, id: String) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: id) as? T else {
            fatalError("Could not instantiate ViewController with identifier: \(id)")
        }

        return viewController
    }

    enum Name: String {
        case main = "Main"
        case detailsInformation = "DetailsInformation"
        case home = "Home"
        case information = "Information"
        case termos = "Termos"
    }
}
