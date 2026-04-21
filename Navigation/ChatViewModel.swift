//
//  ChatViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth

final class ChatViewModel {
    
    private let service = ChatService()
    
    var messages: [Message] = [] {
        didSet { onUpdate?() }
    }
    
    var onUpdate: (() -> Void)?
    
    private var chatId: String?
    
    func start(chatId: String) {
        self.chatId = chatId
        
        service.listenMessages(chatId: chatId) { [weak self] messages in
            self?.messages = messages
        }
    }
    
    func send(text: String) {
        guard
            let chatId = chatId,
            let senderId = Auth.auth().currentUser?.uid,
            !text.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }
        
        service.sendMessage(chatId: chatId, text: text, senderId: senderId)
    }
}
