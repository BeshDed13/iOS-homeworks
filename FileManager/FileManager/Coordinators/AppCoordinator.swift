//
//  AppCoordinator.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    func start()
}

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    var childCoordinators: [Coordinator] = []
    let passwordService = PasswordService()
    let settingsService = SettingsService()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showPasswordFlow()
    }
    
    private func showPasswordFlow() {
        let passwordVM = PasswordViewModel(service: passwordService)
        let passwordVC = PasswordViewController(viewModel: passwordVM)
        
        passwordVC.onSuccess = { [weak self] in
            self?.showTabBar()
        }
        window.rootViewController = UINavigationController(rootViewController: passwordVC)
        window.makeKeyAndVisible()
    }
    
    private func showTabBar() {
        let tabBarCoordinator = TabBarCoordinator(settingsService: settingsService)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = tabBarCoordinator.tabBarController
    }
}
