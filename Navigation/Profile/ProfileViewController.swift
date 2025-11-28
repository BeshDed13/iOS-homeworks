//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 22.11.2025.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    private let headerView = ProfileHeaderView()
    private let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),

            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
}
