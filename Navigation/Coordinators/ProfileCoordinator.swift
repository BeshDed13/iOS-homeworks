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
    
    private var lastUser: User?
    
    private var isAuthorized = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if isAuthorized, let user = lastUser {
            showProfile(user: user)
        } else {
            showLogin()
        }
    }
    
    private func showProfile(user: User) {
        let profileViewController = ProfileViewController()
        profileViewController.coordinator = self
        profileViewController.user = user
        navigationController.setViewControllers([profileViewController], animated: false)
    }
    
    private func showLogin() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    
    func didLoginSuccessfully(user: User) {
        isAuthorized = true
        showProfile(user: user)
    }
}
