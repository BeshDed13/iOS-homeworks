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
                let chats = documents.compactMap { doc -> Chat? in
                    let data = doc.data()
                    
                    guard
                        let participants = data["participants"] as? [String],
                        let lastMessage = data["lastMessage"] as? String,
                        let timestamp = data["lastMessageDate"] as? Timestamp,
                        let lastSenderId = data["lastSenderId"] as? String
                    else { return nil }
                    
                    return Chat(
                        id: doc.documentID,
                        participants: participants,
                        lastMessage: lastMessage,
                        lastMessageDate: timestamp.dateValue(),
                        lastSenderId: lastSenderId
                    )
                }
                
                completion(chats)
            }
    }
    
    func findExistingChat(userIds: [String], completion: @escaping (Chat?) -> Void) {

        let key = userIds.sorted().joined(separator: "_")

        db.collection("chats")
            .whereField("participantsKey", isEqualTo: key)
            .getDocuments { snapshot, _ in

                guard let doc = snapshot?.documents.first else {
                    completion(nil)
                    return
                }

                let data = doc.data()

                guard
                    let participants = data["participants"] as? [String],
                    let lastMessage = data["lastMessage"] as? String,
                    let timestamp = data["lastMessageDate"] as? Timestamp,
                    let lastSenderId = data["lastSenderId"] as? String
                else {
                    completion(nil)
                    return
                }

                let chat = Chat(
                    id: doc.documentID,
                    participants: participants,
                    lastMessage: lastMessage,
                    lastMessageDate: timestamp.dateValue(),
                    lastSenderId: lastSenderId
                )

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
                "lastMessageDate": Timestamp(),
                "lastSenderId": ""
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
                
                let messages = documents.compactMap { doc -> Message? in
                    let data = doc.data()
                    
                    guard
                        let text = data["text"] as? String,
                        let senderId = data["senderId"] as? String,
                        let timestamp = data["createdAt"] as? Timestamp
                    else { return nil }
                    
                    return Message(
                        id: doc.documentID,
                        text: text,
                        senderId: senderId,
                        createdAt: timestamp.dateValue()
                    )
                }
                
                completion(messages)
            }
    }
    
    func sendMessage(chatId: String, text: String, senderId: String) {
        
        let timestamp = Timestamp()
        
        let messageRef = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document()
        
        messageRef.setData([
            "text": text,
            "senderId": senderId,
            "createdAt": timestamp
        ])
        
        db.collection("chats")
            .document(chatId)
            .updateData([
                "lastMessage": text,
                "lastMessageDate": timestamp,
                "lastSenderId": senderId
            ])
    }
}
