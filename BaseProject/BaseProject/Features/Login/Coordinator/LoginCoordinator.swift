//
//  LoginCoordinator.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {

    var window: UIWindow
    var navigation: UINavigationController?

    required init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = LoginViewModel()
        viewModel.delegate = self
        let viewController = LoginViewController.instantiate(with: viewModel)
        self.navigation = UINavigationController(rootViewController: viewController)
        window.rootViewController = self.navigation
    }
}

extension LoginCoordinator: LoginViewModelDelegate {

    func navigateToHome(_ viewModel: LoginViewModel) {
        let homeCoordinator = HomeCoordinator(window: self.window)
        homeCoordinator.start()
    }

}
