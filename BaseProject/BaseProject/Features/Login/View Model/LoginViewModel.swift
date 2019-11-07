//
//  LoginViewModel.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func navigateToHome(_ viewModel: LoginViewModel)
}

protocol LoginViewModelContract {
    func navigateToHome()
}

class LoginViewModel: LoginViewModelContract {

    weak var delegate: LoginViewModelDelegate?

    func navigateToHome() {
        delegate?.navigateToHome(self)
    }
}
