//
//  TabBarCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation
import UIKit

final class TabBarCoordinator: AppCoordinator {
    
    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController
    
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        
        let feedNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()
        
        let feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        
        childCoordinators = [profileCoordinator, feedCoordinator]
        
        feedCoordinator.start()
        profileCoordinator.start()
        
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person.crop.circle"),
                                            selectedImage: UIImage(systemName: "person.crop.circle.fill"))
    
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed",
                                         image: UIImage(systemName: "text.bubble"),
                                         selectedImage: UIImage(systemName: "text.bubble.fill"))
        
        tabBarController.viewControllers = [profileNavigationController, feedNavigationController]
        
        navigationController.setViewControllers([tabBarController], animated: false)

    }
}
