//
//  Checker.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 17.01.2026.
//

import Foundation
import UIKit

final class Checker {
    static let shared = Checker()
    
    private let login: String = "adm"
    private let password: String = "1234"
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}
