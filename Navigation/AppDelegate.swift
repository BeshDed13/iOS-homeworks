//
//  AppDelegate.swift
//  Navigation
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: TabBarCoordinator?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // create tab bar with feed and profile items
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        coordinator = TabBarCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        window.rootViewController = coordinator?.navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}

