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
    var user: User { get set }
    func getUser(login: String) -> User?
}

extension UserService {
    func getUser(login: String) -> User? {
        return login == user.login ? self.user : nil
    }
}

final class CurrentUserService: UserService {
    var user: User
    
    init(user: User) {
        self.user = user
    }
        
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}

final class TestUserService: UserService {
    var user: User
    
    private let testUser = User(login: "test", fullName: "testName", status: "dbgmode", avatar: UIImage(named:"teo")!)
    
    init(user: User) {
        self.user = user
    }
    
    func getUser(login: String) -> User? {
        return testUser
    }
}
