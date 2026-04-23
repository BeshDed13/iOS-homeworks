//
//  SignUpViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 04.04.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel {
    
    func signUp(
        email: String,
        password: String,
        name: String,
        lastName: String,
        birthday: Date,
        gender: String,
        avatar: Avatar,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            self.saveUserToFirestore(
                uid: uid,
                email: email,
                name: name,
                lastName: lastName,
                birthday: birthday,
                gender: gender,
                avatarId: avatar.rawValue,
                completion: completion
            )
        }
    }
    
    private func saveUserToFirestore(
        uid: String,
        email: String,
        name: String,
        lastName: String,
        birthday: Date,
        gender: String,
        avatarId: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": uid,
            "email": email,
            "name": name,
            "lastName": lastName,
            "birthday": Timestamp(date: birthday),
            "gender": gender,
            "avatarId": avatarId,
            "status": "Online"
        ]
        
        db.collection("users").document(uid).setData(data) { error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let user = User(
                login: email,
                fullName: "\(name) \(lastName)",
                status: "Online",
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
