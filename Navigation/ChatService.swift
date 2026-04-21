//
//  ChatService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseFirestore

final class ChatService {
    
    private let db = Firestore.firestore()
    
    func listenChats(userId: String, completion: @escaping ([Chat]) -> Void) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let chats = documents.map { doc -> Chat in
                    let data = doc.data()
                    
                    return Chat(
                        id: doc.documentID,
                        participants: data["participants"] as? [String] ?? [],
                        lastMessage: data["lastMessage"] as? String ?? ""
                    )
                }
                
                completion(chats)
            }
    }
    
    func findExistingChat(userIds: [String], completion: @escaping (Chat?) -> Void) {

        let sorted = userIds.sorted()

        db.collection("chats")
            .whereField("participants", isEqualTo: sorted)
            .getDocuments { snapshot, _ in

                let chat = snapshot?.documents.first.map { doc in
                    Chat(
                        id: doc.documentID,
                        participants: doc["participants"] as? [String] ?? [],
                        lastMessage: doc["lastMessage"] as? String ?? ""
                    )
                }

                completion(chat)
            }
    }
    
    func createChat(with userId: String, currentUserId: String, completion: @escaping (String) -> Void) {

        let users = [userId, currentUserId].sorted()

        findExistingChat(userIds: users) { [weak self] existingChat in

            if let chat = existingChat {
                completion(chat.id)
                return
            }

            let chatRef = self?.db.collection("chats").document()

            chatRef?.setData([
                "participants": users,
                "lastMessage": "",
                "updatedAt": Timestamp()
            ])

            completion(chatRef!.documentID)
        }
    }
    
    func listenMessages(chatId: String, completion: @escaping ([Message]) -> Void) {
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                
                let messages = documents.map { doc -> Message in
                    let data = doc.data()
                    
                    return Message(
                        id: doc.documentID,
                        text: data["text"] as? String ?? "",
                        senderId: data["senderId"] as? String ?? ""
                    )
                }
                
                completion(messages)
            }
    }
    
    func sendMessage(chatId: String, text: String, senderId: String) {
        
        let messageRef = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document()
        
        messageRef.setData([
            "text": text,
            "senderId": senderId,
            "createdAt": Timestamp()
        ])
        
        db.collection("chats")
            .document(chatId)
            .updateData([
                "lastMessage": text,
                "updatedAt": Timestamp()
            ])
    }
}
