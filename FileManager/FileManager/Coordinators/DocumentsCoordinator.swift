//
//  DocumentsCoordinator.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class DocumentsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let settingsService: SettingsService
    
    init(navigationController: UINavigationController,
         settingsService: SettingsService) {
        self.navigationController = navigationController
        self.settingsService = settingsService
    }
    
    func start() {
        let vm = DocumentsViewModel(fileManager: FileService(),
                                    settingsService: settingsService)
        let vc = DocumentsViewController(viewModel: vm)
        vc.title = "Files"
        navigationController.setViewControllers([vc], animated: false)
    }
}
