//
//  SetiingsViewModel.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation

final class SettingsViewModel {
    
    private let settingsService: SettingsService
    
    var isAscending: Bool {
        settingsService.isAscending
    }
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }
    
    func toggleSorting(isOn: Bool) {
        settingsService.isAscending = isOn
    }
}
