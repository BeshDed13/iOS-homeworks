//
//  ChatsCoordinator.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class ChatsCoordinator: AppCoordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [AppCoordinator] = []
    
    private let chatService = ChatService()
    private let findUserService = FindUserService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showChats()
    }
}

extension ChatsCoordinator {
    
    func showChats() {
        let viewModel = ChatsViewModel(service: chatService)
        let chatsViewController = ChatsViewController(viewModel: viewModel)
        chatsViewController.onChatSelected = { [weak self] chat in
            self?.showChat(chatId: chat.id)
        }
        chatsViewController.onAddChat = { [weak self] in
            self?.showNewChat()
        }
        
        navigationController.setViewControllers([chatsViewController], animated: true)
    }
}

extension ChatsCoordinator {
    
    func showChat(chatId: String) {
        let viewModel = ChatViewModel(service: chatService)
        let chatViewController = ChatViewController(viewModel: viewModel, chatId: chatId)
        navigationController.pushViewController(chatViewController, animated: true)
    }
}

extension ChatsCoordinator {
    
    func showNewChat() {
        let viewModel = NewChatViewModel(
            findUserService: findUserService,
            chatService: chatService
        )
        
        let vc = NewChatViewController(viewModel: viewModel)
        
        vc.onChatCreated = { [weak self] chatId in
            self?.navigationController.popViewController(animated: true)
            self?.showChat(chatId: chatId)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
}
