//
//  AppDelegate.swift
//  Navigation
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: LoginCoordinator?
    
    let localNotificationsService = LocalNotificationsService()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        localNotificationsService.registeForLatestUpdatesIfPossible()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        window.rootViewController = coordinator?.navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try Auth.auth().signOut()
            print("User signed out")
        } catch {
            print("Error signing out:", error)
        }
    }
}

