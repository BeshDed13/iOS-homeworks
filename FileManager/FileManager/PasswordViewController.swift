//
//  PasswordViewController.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class PasswordViewController: UIViewController {
    
    private let viewModel: PasswordViewModel
    
    var onSuccess: (() -> Void)?
    
    private let textField = UITextField()
    private let button = UIButton(type: .system)
    
    init(viewModel: PasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [textField, button])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateUI() {
        switch viewModel.state {
        case .create:
            button.setTitle("Create password", for: .normal)
        case .confirm:
            button.setTitle("Confirm password", for: .normal)
        case .enter:
            button.setTitle("Enter password", for: .normal)
        }
    }
    
    @objc private func buttonTaped() {
        do {
            let success = try viewModel.handleInput(textField.text)
            if success {
                onSuccess?()
            } else {
                updateUI()
            }
            textField.text = ""
        } catch {
            showAlert(message: error.localizedDescription)
            textField.text = ""
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
