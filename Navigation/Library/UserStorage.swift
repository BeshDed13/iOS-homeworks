//
//  UserStorage.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 11.03.2026.
//

import Foundation

final class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    private var savedUser: User?
    
    func save(_ user: User) {
        savedUser = user
    }
    
    func getUser() -> User? {
        return savedUser
    }
}
