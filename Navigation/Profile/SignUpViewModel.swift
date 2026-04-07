//
//  SignUpViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 04.04.2026.
//

import UIKit
import FirebaseAuth

final class SignUpViewModel {
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void) {
            
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let firebaseUser = result?.user {
                
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
    
    func handleAuthError(_ error: Error) -> String {
        
        let nsError = error as NSError
        
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .wrongPassword:
                return "alert_wrong_password".localized
            case .userNotFound:
                return "alert_user_not_found".localized
            default:
                return error.localizedDescription
            }
        }
        
        return error.localizedDescription
    }
}
