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
    var coordinator: TabBarCoordinator?
    
    var appConfigutation: AppConfiguration!
    
    let localNotificationsService = LocalNotificationsService()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let urls = [
            URL(string: "https://swapi.dev/api/people/8/")!,
            URL(string: "https://swapi.dev/api/starships/3/")!,
            URL(string: "https://swapi.dev/api/planets/5/")!
        ]
        
        let randIndex = Int.random(in: 0..<urls.count)
        
        switch randIndex {
        case 0:
            appConfigutation = .people(urls[0])
        case 1:
            appConfigutation = .starships(urls[1])
        default:
            appConfigutation = .planets(urls[2])
        }
        
        NetworkService.request(for: appConfigutation)
        FirebaseApp.configure()
        
        localNotificationsService.registeForLatestUpdatesIfPossible()
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try Auth.auth().signOut()
            print("User signed out")
        } catch {
            print("Error signing out:", error)
        }
    }
}

