//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 12.04.2026.
//

import FirebaseAuth
import FirebaseFirestore

final class ProfileViewModel {
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            let name = data["name"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            let status = data["status"] as? String ?? ""
            
            let user = User(
                login: data["email"] as? String ?? "",
                fullName: "\(name) \(lastName)",
                status: status,
                avatar: UIImage(named: "teo")!
            )
            
            completion(.success(user))
        }
    }
}
