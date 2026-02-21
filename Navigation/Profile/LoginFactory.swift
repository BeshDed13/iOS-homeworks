//
//  LoginFactory.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 17.01.2026.
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        let checkerService = Checker()
        return LoginInspector(checkerService: checkerService)
    }
}
