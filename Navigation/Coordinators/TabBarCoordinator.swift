//
//  TabBarCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

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
        let favoritesNavigationController = UINavigationController()
        let mapNavigationController = UINavigationController()
        let chatsNavigationController = UINavigationController()
        
        let feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController)
        let mapCoordinator = MapCoordinator(navigationController: mapNavigationController)
        let chatsCoordinator = ChatsCoordinator(navigationController: chatsNavigationController)
        
        childCoordinators = [profileCoordinator, feedCoordinator, chatsCoordinator, favoritesCoordinator, mapCoordinator]
        
        feedCoordinator.start()
        profileCoordinator.start()
        favoritesCoordinator.start()
        mapCoordinator.start()
        chatsCoordinator.start()
        
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль",
                                            image: UIImage(systemName: "person.crop.circle"),
                                            selectedImage: UIImage(systemName: "person.crop.circle.fill"))
    
        feedNavigationController.tabBarItem = UITabBarItem(title: "Лента",
                                         image: UIImage(systemName: "text.bubble"),
                                         selectedImage: UIImage(systemName: "text.bubble.fill"))
        
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Избранное",
                                            image: UIImage(systemName: "star"),
                                            selectedImage: UIImage(systemName: "star.fill"))
        
        mapNavigationController.tabBarItem = UITabBarItem(title: "Карты",
                                                          image: UIImage(systemName: "map"),
                                                          selectedImage: UIImage(systemName: "map.fill"))
        
        chatsNavigationController.tabBarItem = UITabBarItem(title: "Чаты",
                                                            image: UIImage(systemName: "bubble.left"),
                                                            selectedImage: UIImage(systemName: "bubble.left.fill"))
                                                          
        tabBarController.viewControllers = [profileNavigationController, feedNavigationController, chatsNavigationController, favoritesNavigationController, mapNavigationController]
        
        navigationController.setViewControllers([tabBarController], animated: true)

    }
}
