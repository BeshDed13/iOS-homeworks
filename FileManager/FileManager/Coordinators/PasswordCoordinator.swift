//
//  PasswordCoordinator.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class PasswordCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let passwordService: PasswordService
    var onSuccess: (() -> Void)?
    
    init(navigationController: UINavigationController,
         passwordService: PasswordService) {
        self.navigationController = navigationController
        self.passwordService = passwordService
    }
    
    func start() {
        let vm = PasswordViewModel(service: passwordService)
        let vc = PasswordViewController(viewModel: vm)
        
        vc.onSuccess = { [weak self] in
            self?.onSuccess?()
        }
        
        navigationController.present(vc, animated: true)
    }
}
