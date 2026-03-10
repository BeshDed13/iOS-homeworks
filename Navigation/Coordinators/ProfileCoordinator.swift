//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import UIKit
import FirebaseAuth

final class ProfileCoordinator: AppCoordinator {

    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func didLoginSuccessfully(user: User) {
        let profileVC = ProfileViewController()
        profileVC.user = user
        navigationController.setViewControllers([profileVC], animated: true)
    }
}

    
    func signUp(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: login, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            if let firebaseUser = Auth.auth().currentUser {
                let user = User(
                    login: firebaseUser.email ?? "",
                    fullName: firebaseUser.email ?? "",
                    status: "Online",
                    avatar: UIImage(named: "teo")!
                )
                completion(.success(user))
            }
        }
    }
