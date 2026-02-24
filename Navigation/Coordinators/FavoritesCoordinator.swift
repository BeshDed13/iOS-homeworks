//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class FavoritesCoordinator: AppCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [AppCoordinator] = []
    
    private let favoritesService = FavoritesService()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let favoritesService = FavoritesService()
        let favoritesVC = FavoritesViewController(favoritesService: favoritesService)
        favoritesVC.title = "Favorites"
        navigationController.setViewControllers([favoritesVC], animated: false)
    }
}
