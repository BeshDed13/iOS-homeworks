//
//  FeedModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 26.01.2026.
//

import Foundation

final class FeedModel {
    
    private let secretWord = "secret word"
    
    func check(word: String) -> Bool {
        return word.lowercased() == secretWord
    }
}
