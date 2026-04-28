//
//  FindUserService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseFirestore

final class FindUserService {
    
    private let db = Firestore.firestore()
    
    private var searchWorkItem: DispatchWorkItem?
    
    func findUsers(query: String, completion: @escaping ([ChatUser]) -> Void) {
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            completion([])
            return
        }
        
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: trimmedQuery, completion: completion)
        }
        
        searchWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
    private func performSearch(query: String, completion: @escaping ([ChatUser]) -> Void) {
        
        let lowercasedQuery = query.lowercased()
        
        db.collection("users")
            .limit(to: 20)
            .getDocuments(completion: { snapshot, error in
                
                if let error = error {
                    print("Firestore error:", error)
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let users = documents.compactMap { doc -> ChatUser? in
                    let data = doc.data()
                    
                    let firstName = data["name"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    
                    let fullName = "\(firstName) \(lastName)"
                    
                    guard fullName.lowercased().contains(lowercasedQuery) else {
                        return nil
                    }
                    
                    guard let avatarRaw = data["avatarId"] as? String,
                        let avatar = Avatar(rawValue: avatarRaw) else {
                        return nil
                    }
                    
                    guard let timestamp = data["birthday"] as? Timestamp else {
                        return nil
                    }
                    
                    let birthday = timestamp.dateValue()
                    
                    if fullName.lowercased().contains(lowercasedQuery) {
                        return ChatUser(
                            id: doc.documentID,
                            firstName: firstName,
                            lastName: lastName,
                            birthday: birthday,
                            avatar: avatar
                        )
                    }
                    
                    return nil
                }
                completion(users)
            })
    }
}
