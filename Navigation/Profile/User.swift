//
//  User.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 17.01.2026.
//

import UIKit

final class User {
    let login: String
    let fullName: String
    let status: String
    let avatarId: String
    
    init(login: String, fullName: String, status: String, avatarId: String) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.avatarId = avatarId
    }
}
