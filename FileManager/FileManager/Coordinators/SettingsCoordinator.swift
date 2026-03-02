//
//  SettingsCoordinator.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class SettingsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let settingsService: SettingsService
    
    init(navigationController: UINavigationController,
         settingsService: SettingsService) {
        self.navigationController = navigationController
        self.settingsService = settingsService
    }
    
    func start() {
        let vm = SettingsViewModel(settingsService: settingsService)
        let vc = SettingsViewController(viewModel: vm)
        
        vc.onChangePassword = { [weak self] in
            self?.showChangePassword()
        }
        
        vc.title = "Settings"
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showChangePassword() {
        let passwordVM = PasswordViewModel(service: PasswordService())
        let passwordVC = PasswordViewController(viewModel: passwordVM)
        passwordVC.modalPresentationStyle = .formSheet
        
        passwordVC.onSuccess = { [weak self] in
            passwordVC.dismiss(animated: true)
        }
        
        navigationController.present(passwordVC, animated: true)
    }
}
