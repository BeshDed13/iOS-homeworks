//
//  MapCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 01.03.2026.
//

import UIKit

final class MapCoordinator: AppCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [AppCoordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = MapService()
        let vc = MapViewController(mapService: service)
        navigationController.pushViewController(vc, animated: true)
    }
}
