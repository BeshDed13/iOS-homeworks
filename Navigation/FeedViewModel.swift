//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation

final class FeedViewModel {
    
    private let model: FeedModel
    
    var onResult: ((Bool) -> Void)?
    
    init(model: FeedModel = FeedModel()) {
        self.model = model
    }
    
    func checkWord(_ word: String?) {
        guard let word = word, !word.isEmpty else {
            onResult?(false)
            return
        }
        
        let result = model.check(word: word)
        onResult?(result)
    }
}
