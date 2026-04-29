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
    let gender: String
    let birthday: Date?
    
    init(login: String, fullName: String, status: String, avatarId: String, gender: String, birthday: Date) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.avatarId = avatarId
        self.gender = gender
        self.birthday = birthday
    }
}
