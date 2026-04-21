//
//  SignUpViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 04.04.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class SignUpViewModel {
    
    func signUp(
        email: String,
        password: String,
        name: String,
        lastName: String,
        birthday: Date,
        gender: String,
        avatar: UIImage?,
        completion: @escaping (Result<User, Error>) -> Void) {
            
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            self.uploadAvatar(uid: uid, image: avatar) { avatarURL in
                
                self.saveUserToFirestore(
                    uid: uid,
                    email: email,
                    password: password,
                    name: name,
                    lastName: lastName,
                    birthday: birthday,
                    gender: gender,
                    avatarURL: avatarURL
                ) { result in
                    completion(result)
                }
            }
        }
    }
    
    private func uploadAvatar(
        uid: String,
        image: UIImage?,
        completion: @escaping (String?) -> Void
    ) {
        
        guard let image = image,
              let data = image.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        let ref = Storage.storage().reference().child("avatars/\(uid).jpg")
        ref.putData(data, metadata: nil) { _, error in
            
            if error != nil {
                completion(nil)
                return
            }
            
            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
    
    private func saveUserToFirestore(
        uid: String,
        email: String,
        password: String,
        name: String,
        lastName: String,
        birthday: Date,
        gender: String,
        avatarURL: String?,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "uid": uid,
            "email": email,
            "password": password,
            "name": name,
            "lastName": lastName,
            "birthday": Timestamp(date: birthday),
            "gender": gender,
            "avatarURL": avatarURL ?? "",
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
                avatar: UIImage(named: "teo")!
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
