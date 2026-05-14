//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import UIKit

final class ProfileCoordinator: AppCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [AppCoordinator] = []
    
    var onLogout: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProfileViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didLogout() {
        onLogout?()
    }
    
    func openSettings() {
        let vc = SettingsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
