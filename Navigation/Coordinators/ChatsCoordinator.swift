//
//  ChatsCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class ChatsCoordinator: AppCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [AppCoordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChatsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
