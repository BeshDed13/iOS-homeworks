//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation
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
        loginVC.loginDelegate = self
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func didLoginSuccessfully(user: User) {
        let profileVC = ProfileViewController()
        profileVC.user = user
        navigationController.setViewControllers([profileVC], animated: true)
    }
}

// MARK: - LoginViewControllerDelegate

extension ProfileCoordinator: LoginViewControllerDelegate {
    
    func checkCredentials(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: login, password: password) { [weak self] result, error in
            
            if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                // Пользователя нет → сообщаем об ошибке, дальше VC вызовет signUp
                completion(.failure(error))
                return
            } else if let error = error {
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
}
