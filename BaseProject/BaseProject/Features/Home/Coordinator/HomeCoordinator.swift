//
//  HomeCoordinator.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 08/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {

    var window: UIWindow
    var navigation: UINavigationController?

    required init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = HomeViewModel()
        viewModel.delegate = self
        let viewController = HomeViewController.instantiate(with: viewModel)
        self.navigation = UINavigationController(rootViewController: viewController)
        window.rootViewController = self.navigation
    }

}

extension HomeCoordinator: HomeViewModelDelegate {

    func navigateToDetail() {
        
    }

}

