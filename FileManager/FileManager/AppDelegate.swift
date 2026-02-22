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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = DocumentsViewController()
        let navigation = UINavigationController(rootViewController: vc)
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        self.window = window
        return true
    }
}
