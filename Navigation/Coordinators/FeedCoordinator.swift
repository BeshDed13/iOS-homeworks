//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 29.01.2026.
//

import Foundation
import UIKit

final class FeedCoordinator: AppCoordinator {

    var childCoordinators: [AppCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feedViewController = FeedViewController()
        feedViewController.coordinator = self
        navigationController.pushViewController(feedViewController, animated: false)
    }

    func openPost(_ post: Post) {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController.pushViewController(postViewController, animated: false)
    }
}
