//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation
import UIKit

protocol AppCoordinator: AnyObject {
    
    var childCoordinators: [AppCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
