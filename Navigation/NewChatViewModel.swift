//
//  NewChatViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth

final class NewChatViewModel {
    
    private let findUserService = FindUserService()
    private let chatService = ChatService()
    
    var users: [ChatUser] = [] {
        didSet { onUpdate?() }
    }
    
    var onUpdate: (() -> Void)?
    
    var onChatCreated: ((String) -> Void)?
    
    func search(text: String) {
        findUserService.findUsers(query: text) { [weak self] users in
            DispatchQueue.main.async {
                self?.users = users
            }
        }
    }
    
    func selectUser(_ user: ChatUser) {
        guard let currentUserId = getCurrentUserId() else { return }
        
        chatService.createChat(with: user.id, currentUserId: currentUserId) { [weak self] chatId in
            DispatchQueue.main.async {
                self?.onChatCreated?(chatId)
            }
        }
    }
    
    private func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
