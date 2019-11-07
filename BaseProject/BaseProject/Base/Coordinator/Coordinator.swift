//
//  AppDelegate.swift
//  PSMyAccount
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var window: UIWindow { get set }

    init(window: UIWindow)

    func start()
}
