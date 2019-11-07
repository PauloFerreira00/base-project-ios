//
//  AppDelegate.swift
//  PSMyAccount
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow
    var coordinators = [String: Coordinator]()
    var isLoggedIn = false
    var isInvalidToken = false
    var foregroundWindow: UIWindow

    required init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .clear
        self.window.makeKeyAndVisible()
        self.foregroundWindow = UIWindow(frame: UIScreen.main.bounds)
    }

    func start() {
        let isLoggedIn: Bool = false
        if isLoggedIn {
            // Home
        } else {
           // Login
        }
    }
    
    func invalidate() {
        isInvalidToken = true
//        showLogin()
    }

}
//
//extension AppCoordinator: OnboardingCoordinatorDelegate {
//    func showOnboarding() {
//        isLoggedIn = false
//        onboardingCoordinator = OnboardingCoordinator()
//        onboardingCoordinator?.delegate = self
//        window.rootViewController = onboardingCoordinator?.navigation
//
//        isInvalidToken = false
//    }
//
//    func onboardingCoordinatorDidRequestSignIn(_ onboardingCoordinator: OnboardingCoordinator) {
//        self.showLogin()
//    }
//
//    func onboardingCoordinatorDidFinishSignUp(_ onboardingCoordinator: OnboardingCoordinator) {
//        loginCoodinatorDidFinish()
//        onboardingCoordinator.stop()
//    }
//}

//extension AppCoordinator: LoginCoordinatorDelegate {
//    func showLogin() {
//        AppSecurityProfiler.context = .login
//        isLoggedIn = false
//        loginCoordinator = LoginCoordinator(window: self.window)
//        loginCoordinator?.delegate = self
//        loginCoordinator?.start(isInvalidToken: isInvalidToken)
//    }

//    func loginCoordinatorDidFinish(loginCoordinator: LoginCoordinator) {
//        loginCoodinatorDidFinish()
//        loginCoordinator.stop()
//        self.loginCoordinator = nil
//    }
//}
