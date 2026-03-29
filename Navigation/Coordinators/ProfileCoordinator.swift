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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProfileViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
