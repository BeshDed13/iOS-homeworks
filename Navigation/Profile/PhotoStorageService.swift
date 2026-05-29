//
//  PhotoStorageService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 14.05.2026.
//

import UIKit

final class PhotoStorageService {

    private let fileManager = FileManager.default

    private var directoryURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func save(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }

        let fileName = UUID().uuidString + ".jpg"
        let fileURL = directoryURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Save error:", error)
            return nil
        }
    }

    func loadAllImages() -> [UIImage] {
        do {
            let files = try fileManager.contentsOfDirectory(at: directoryURL,
                                                             includingPropertiesForKeys: nil)

            return files.compactMap { url in
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else { return nil }
                return image
            }
        } catch {
            print("Load error:", error)
            return []
        }
    }
}
