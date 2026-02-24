//
//  DocumentsViewModel.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class DocumentsViewModel {
    
    private let fileManager: FileService
    private let settingsService: SettingsService
    
    private(set) var files: [URL] = []
    
    init(fileManager: FileService, settingsService: SettingsService) {
        self.fileManager = fileManager
        self.settingsService = settingsService
    }
    
    func loadFiles() {
        let fetched = fileManager.fetchFiles()
        
        files = fetched.sorted {
            settingsService.isAscending
            ? $0.lastPathComponent < $1.lastPathComponent
            : $0.lastPathComponent > $1.lastPathComponent
        }
    }
    
    func delete(at index: Int) {
        let fileURL = files[index]
        fileManager.deleteFile(at: fileURL)
        files.remove(at: index)
    }
    
    func save(image: UIImage) {
        fileManager.saveImage(image)
        loadFiles()
    }
}
