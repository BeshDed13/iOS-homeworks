//
//  PasswordService.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import KeychainAccess

final class PasswordService {
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    private let key: String = "password"
    
    func save(password: String) throws {
        try keychain.set(password, key: key)
    }
    
    func get() throws -> String? {
        return try? keychain.get(key)
    }
    
    func hasPassword() throws -> Bool {
        return try get() != nil
    }
    
    func delete() throws {
        try keychain.remove(key)
    }
}
