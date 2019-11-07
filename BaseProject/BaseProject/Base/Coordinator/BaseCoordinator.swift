//
//  BaseCoordinator.swift
//  PSMyAccount
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation
import UIKit
/// PresentationType
///
/// - push: push for navigationController
/// - modal: present for viewController
enum PresentationType {
    case push(navigationController: UINavigationController)
    case modal(viewController: UIViewController)
    
    func associatedValue() -> Any? {
        switch self {
        case .push(let value):
            return value
        case .modal(let value):
            return value
        }
    }
}

/// Protocol Base Coordninator
protocol BaseCoordinator: AnyObject {
    
    /// Associated type of UIViewController for start coordinator
    associatedtype V: UIViewController
    
    /// View for start coordinator
    var view: V? { get set }
    
    /// Navigation Controller
    var navigation: UINavigationController? { get set }
    
    /// Presentation type for start your coordinator
    var presentationType: PresentationType? { get set }
    
    /// Start coordinator with return UIViewController
    ///
    /// - Returns: return view
    func start() -> V
    
    /// Start coordinator with presentation type
    ///
    /// - Parameter presentation: PresentationType that can be push or modal
    func start(usingPresentation presentation: PresentationType)
    
    /// Stop all properties stored in your coordinator
    func stop()
}

// MARK: - BaseCoordinator
extension BaseCoordinator {
    
    /// Start coordinator with return UIViewController
    ///
    /// - Returns: return view
    func start() -> V {
        if view == nil {
            fatalError("You cannot start coordinator without initialize property view!")
        }
        return self.view!
    }
    
    /// Start coordinator with presentation type
    ///
    /// - Parameter presentation: PresentationType that can be push or modal
    func start(usingPresentation presentation: PresentationType) {
        presentationType = presentation
        print(presentation.associatedValue() ?? "none")
        switch presentationType {
        case .push(let navigation)?:
            self.navigation = navigation
            navigation.pushViewController(start(), animated: true)
        case .modal(let navigation)?:
            self.navigation = UINavigationController(rootViewController: start())
            guard let nav = self.navigation else { return }
            navigation.present(nav, animated: true, completion: nil)
        case .none:
            break
        }
    }
    
    /// Add left UIBarButtonItem on navigationBar
    ///
    /// - Parameters:
    ///   - image: the image to show on button
    ///   - action: cutom action for tap
    func addLeftNavigationButton(image: UIImage, action: @escaping (() -> Void)) {
//        self.navigation?.navigationItem.leftBarButtonItem = UIBarButtonItem.createCloseButton(withImage: image, andAction: action)
    }
}
