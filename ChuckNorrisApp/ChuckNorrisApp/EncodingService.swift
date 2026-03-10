//
//  EncodingService.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 25.02.2026.
//

import Foundation
import Security

final class EncodingService {
    
    private let keychainKey = "chuck-norris-keychain-key"
    
    func getKey() -> Data {
        if let existingKey = loadKey() {
            return existingKey
        }
        
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 64, $0.baseAddress!)
        }
        
        guard result == errSecSuccess else {
            fatalError("Failed to generate key")
        }
        
        saveKey(keyData)
        
        return keyData
    }
    
    private func saveKey(_ key: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: key
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadKey() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
}
