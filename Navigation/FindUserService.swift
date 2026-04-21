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
                    
                    if fullName.lowercased().contains(lowercasedQuery) {
                        return ChatUser(
                            id: doc.documentID,
                            firstName: firstName,
                            lastName: lastName
                        )
                    }
                    
                    return nil
                }
                completion(users)
            })
    }
}
