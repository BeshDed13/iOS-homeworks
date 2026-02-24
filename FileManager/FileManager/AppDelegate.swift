//
//  AppDelegate.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 22.02.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator(window: window)
        coordinator.start()
        
        // Override point for customization after application launch.
        self.window = window
        self.appCoordinator = coordinator
        return true
    }
}
