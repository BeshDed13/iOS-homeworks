//
//  TabBarCoordinator.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class TabBarCoordinator: Coordinator {
    
    let tabBarController = UITabBarController()
    private let settingsService: SettingsService
    private var childCoordinators: [Coordinator] = []
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }
    
    func start() {
        let docsNav = UINavigationController()
        docsNav.tabBarItem.title = "Documents"
        let docsCoordinator = DocumentsCoordinator(
            navigationController: docsNav,
            settingsService: settingsService
        )
        docsCoordinator.start()
        childCoordinators.append(docsCoordinator)
        
        let settingsNav = UINavigationController()
        settingsNav.tabBarItem.title = "Settings"
        let settingsCoordinator = SettingsCoordinator(
            navigationController: settingsNav,
            settingsService: settingsService
        )
        settingsCoordinator.start()
        childCoordinators.append(settingsCoordinator)

        tabBarController.viewControllers = [docsNav, settingsNav]
    }
}
