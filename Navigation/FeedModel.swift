//
//  FeedModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 26.01.2026.
//

import Foundation

final class FeedModel {
    
    private let secretWord = "Secret word"
    
    var onCheckResult: ((Bool) -> Void)?
    
    func check(word: String) {
        let isCorrect = word == secretWord
        onCheckResult?(isCorrect)
    }
}
