//
//  Checker.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 17.01.2026.
//

import UIKit
import FirebaseAuth

protocol CheckerServiceProtocol {
    
    func checkCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    )
    
    func signUp(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    )
}

final class Checker: CheckerServiceProtocol {
    
    func checkCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: login, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let firebaseUser = Auth.auth().currentUser {
                let user = User(
                    login: firebaseUser.email ?? "",
                    fullName: firebaseUser.email ?? "",
                    status: "Online",
                    avatarId: "avatar1"
                )
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "Checker", code: 0, userInfo: [NSLocalizedDescriptionKey: "User data missing"])))
            }
        }
    }
    
    func signUp(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
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
                    avatarId: "avatar1"
                )
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "Checker", code: 0, userInfo: [NSLocalizedDescriptionKey: "User data missing"])))
            }
        }
    }
}

protocol LoginViewControllerDelegate {
    
    func checkCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    )
    
    func signUp(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    )
}

final class LoginInspector: LoginViewControllerDelegate {
    
    private let checkerService: CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }
    
    func checkCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        checkerService.checkCredentials(
            login: login,
            password: password,
            completion: completion
        )
    }
    
    func signUp(
        login: String,
        password: String,
        completion: @escaping (Result<User, any Error>) -> Void
    ) {
        checkerService.signUp(
            login: login,
            password: password,
            completion: completion)
    }
}
