//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 14.03.2026.
//

import UIKit
import FirebaseAuth

final class LoginCoordinator: AppCoordinator {

    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = LogInViewModel()
        let loginVC = LoginViewController(coordinator: self, viewModel: viewModel)
        loginVC.coordinator = self
        
        navigationController.setViewControllers([loginVC], animated: true)
    }

    func didLoginSuccessfully(user: User) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func showSignUp() {
        let signUpVC = SignUpViewController(
            coordinator: self,
            viewModel: SignUpViewModel()
        )
        navigationController.pushViewController(signUpVC, animated: true)
    }
}

