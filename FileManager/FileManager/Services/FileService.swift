//
//  FileService.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 22.02.2026.
//

import Foundation
import UIKit

final class FileService {
    
    private let fileManager = FileManager.default
    
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func fetchFiles() -> [URL] {
        let files = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        return files ?? []
    }
    
    func saveImage(_ image: UIImage) {
        let fileName = UUID().uuidString + ".png"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    func deleteFile(at url: URL) {
        try? fileManager.removeItem(at: url)
    }
}
