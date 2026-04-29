//
//  Chat.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import Foundation

struct Chat {
    let id: String
    let participants: [String]
    let lastMessage: String
    let lastMessageDate: Date
    let lastSenderId: String
}
