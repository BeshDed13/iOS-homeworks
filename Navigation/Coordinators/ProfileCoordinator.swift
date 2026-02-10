//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation
import UIKit

final class ProfileCoordinator: AppCoordinator {

    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        loginVC.loginDelegate = self
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func didLoginSuccessfully(user: User) {
        let profileVC = ProfileViewController()
        profileVC.user = user
        navigationController.setViewControllers([profileVC], animated: true)
    }
}

extension ProfileCoordinator: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return login == "adm" && password == "1234"
    }
}
