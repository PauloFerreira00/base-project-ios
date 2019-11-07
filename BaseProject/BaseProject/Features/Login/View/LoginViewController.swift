//
//  LOGINViewController.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Identifiable {

    var viewModel: LoginViewModelContract!

    static func instantiate(with viewModel: LoginViewModelContract) -> LoginViewController {
        let viewController: LoginViewController = UINib.instantiateViewController(from: .login)
        viewController.viewModel = viewModel
        return viewController
    }
    @IBAction func didTapLoginButton() {
        viewModel.navigateToHome()
    }
}
