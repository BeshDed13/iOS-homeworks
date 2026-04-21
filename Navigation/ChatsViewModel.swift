//
//  ChatsViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth

final class ChatsViewModel {
    
    private let service = ChatService()
    
    var chats: [Chat] = [] {
        didSet { onUpdate?()}
    }
    
    var onUpdate: (() -> Void)?
    
    func startListening() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        service.listenChats(userId: uid) { [weak self] chats in
            self?.chats = chats
        }
    }
}
