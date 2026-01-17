//
//  User.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 17.01.2026.
//

import Foundation
import UIKit

final class User {
    let login: String
    let fullName: String
    let status: String
    let avatar: UIImage
    
    init(login: String, fullName: String, status: String, avatar: UIImage) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.avatar = avatar
    }
}

protocol UserService {
    func getUser(login: String) -> User?
}

final class CurrentUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
        
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}

final class TestUserService: UserService {
    private let testUser = User(login: "test", fullName: "testName", status: "dbgmode", avatar: UIImage(named:"teo")!)
    
    func getUser(login: String) -> User? {
        return testUser
    }
}
