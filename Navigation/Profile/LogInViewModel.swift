//
//  LogInViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 10.03.2026.
//

import UIKit
import FirebaseAuth

final class LogInViewModel {
    
    func logIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            if let firebaseUser = result?.user {

                let user = User(
                    login: firebaseUser.email ?? "",
                    fullName: firebaseUser.email ?? "",
                    status: "Онлайн",
                    avatar: UIImage(named: "teo")!
                )

                completion(.success(user))
            }
        }
    }
    
    func handleAuthError(_ error: Error) -> String {
        
        let nsError = error as NSError
        
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .wrongPassword:
                return "Неверный логин или пароль"
            case .userNotFound:
                return "Пользователь не найден"
            default:
                return error.localizedDescription
            }
        }
        
        return error.localizedDescription
    }
}
