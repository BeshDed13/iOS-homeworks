//
//  SettingsService.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation

final class SettingsService {
    
    enum Keys {
        static let isAscending = "isAscending"
    }
    
    var isAscending: Bool {
        get {
            if UserDefaults.standard.object(forKey: Keys.isAscending) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: Keys.isAscending)
        } set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAscending)
        }
    }
}
