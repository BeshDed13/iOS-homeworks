//
//  ChatsViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ChatsViewModel {
    
    private let service: ChatService
    private let db = Firestore.firestore()
    
    private var usersCache: [String: User] = [:]
    
    var items: [ChatItem] = [] {
        didSet { onUpdate?() }
    }
    
    var onUpdate: (() -> Void)?
    
    init(service: ChatService) {
        self.service = service
    }
    
    func startListening() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        service.listenChats(userId: uid) { [weak self] chats in
            self?.processChats(chats, currentUid: uid)
        }
    }
    
    private func processChats(_ chats: [Chat], currentUid: String) {
        
        var result: [ChatItem] = []
        
        for chat in chats {
            
            guard let companionId = chat.participants.first(where: { $0 != currentUid }) else {
                continue
            }
            
            if let user = usersCache[companionId] {
                let item = makeItem(chat: chat, user: user)
                result.append(item)
                continue
            }
            
            db.collection("users").document(companionId).getDocument { [weak self] doc, _ in
                
                guard let self = self else { return }
                guard let data = doc?.data() else { return }
                
                let user = User(
                    login: companionId,
                    fullName: "\(data["name"] as? String ?? "") \(data["lastName"] as? String ?? "")",
                    status: data["status"] as? String ?? "",
                    avatarId: data["avatarId"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    birthday: (data["birthday"] as? Timestamp)?.dateValue() ?? Date()
                )
                
                self.usersCache[companionId] = user
                
                let item = self.makeItem(chat: chat, user: user)
                
                result.append(item)
                
                DispatchQueue.main.async {
                    self.items = result.sorted { $0.date > $1.date }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.items = result.sorted { $0.date > $1.date }
        }
    }
    
    private func makeItem(chat: Chat, user: User) -> ChatItem {
        ChatItem(
            id: chat.id,
            name: user.fullName,
            avatarId: user.avatarId,
            lastMessage: chat.lastMessage,
            date: chat.lastMessageDate,
            isOnline: user.status == "Online"
        )
    }
}
