//
//  HomeViewController.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Identifiable {

    static func instantiate() -> HomeViewController {
        let viewController: HomeViewController = UINib.instantiateViewController(from: .home)
        return viewController
    }

}
