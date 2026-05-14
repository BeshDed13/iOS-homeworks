//
//  SettingsViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 06.05.2026.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Скоро тут будут все настройки"
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(emptyLabel)
        
        view.backgroundColor = AppColors.firstBackground
        
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
}
