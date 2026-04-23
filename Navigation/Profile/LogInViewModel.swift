//
//  LogInViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 10.03.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LogInViewModel {
    
    func logIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            self.fetchUserFromFirestore(uid: uid, email: email, completion: completion)
        }
    }
    
    private func fetchUserFromFirestore(
        uid: String,
        email: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            let name = data["name"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            let status = data["status"] as? String ?? "Online"
            let avatarId = data["avatarId"] as? String ?? "avatar1"
            
            let user = User(
                login: email,
                fullName: "\(name) \(lastName)",
                status: status,
                avatarId: avatarId
            )
            
            completion(.success(user))
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
