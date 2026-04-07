//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 14.03.2026.
//

import UIKit
import FirebaseAuth

final class LoginCoordinator: AppCoordinator {

    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }

    func didLoginSuccessfully(user: User) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func showSignUp() {
        let signUpVC = SignUpViewController(
            coordinator: self,
            viewModel: SignUpViewModel()
        )
        navigationController.pushViewController(signUpVC, animated: true)
    }
}

 /* func signUp(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
    
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
} */
