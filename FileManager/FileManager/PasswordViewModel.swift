//
//  PasswordViewModel.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation

enum PasswordState {
    
    case create
    case confirm(firstPassword: String)
    case enter
}

enum PasswordError: LocalizedError {
    
    case tooShort
    case notMatch
    case wrongPassword
    
    var errorDescription: String? {
        switch self {
        case .tooShort:
            return "Password must be at least 4 symbols"
        case .notMatch:
            return "Passwords do not match"
        case .wrongPassword:
            return "Wrong password"
        }
    }
}

final class PasswordViewModel {
    
    private let service: PasswordService
    private(set) var state: PasswordState
    
    init(service: PasswordService) {
        self.service = service
        
        do {
            if try service.hasPassword() {
                self.state = .enter
            } else {
                self.state = .create
            }
        } catch {
            self.state = .create
        }
    }
    
    func handleInput(_ text: String?) throws -> Bool {
        
        guard let text = text, text.count >= 4 else {
            throw PasswordError.tooShort
        }
        
        switch state {
            
        case .create:
            state = .confirm(firstPassword: text)
            return false
            
        case .confirm(let firstPassword):
            
            if firstPassword == text {
                try service.save(password: text)
                return true
            } else {
                state = .create
                throw PasswordError.notMatch
            }
            
        case .enter:
            
            if try service.get() == text {
                return true
            } else {
                throw PasswordError.wrongPassword
            }
        }
    }
}
