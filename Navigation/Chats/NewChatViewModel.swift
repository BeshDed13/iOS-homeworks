//
//  NewChatViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth

final class NewChatViewModel: NewChatViewModelProtocol {
    
    private let findUserService: FindUserService
    private let chatService: ChatService
    
    var users: [ChatUser] = [] {
        didSet { onUpdate?() }
    }
    
    var onUpdate: (() -> Void)?
    var onChatCreated: ((String) -> Void)?
    
    init(
        findUserService: FindUserService,
        chatService: ChatService
    ) {
        self.findUserService = findUserService
        self.chatService = chatService
    }
    
    func search(text: String) {
        findUserService.findUsers(query: text) { [weak self] users in
            DispatchQueue.main.async {
                self?.users = users
            }
        }
    }
    
    func selectUser(_ user: ChatUser) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        chatService.createChat(with: user.id, currentUserId: currentUserId) { [weak self] chatId in
            DispatchQueue.main.async {
                self?.onChatCreated?(chatId)
            }
        }
    }
}

protocol NewChatViewModelProtocol {
    var users: [ChatUser] { get }
    var onUpdate: (() -> Void)? { get set }
    var onChatCreated: ((String) -> Void)? { get set }
    
    func search(text: String)
    func selectUser(_ user: ChatUser)
}
