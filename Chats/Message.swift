//
//  Message.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation
import FirebaseAuth

struct Message {
    let id: String
    let text: String
    let senderId: String
    let createdAt: Date
    
    var isCurrentUser: Bool {
        return senderId == Auth.auth().currentUser?.uid
    }
}
