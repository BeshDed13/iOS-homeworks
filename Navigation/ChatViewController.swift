//
//  ChatViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    private let textField = UITextField()
    private let sendButton = UIButton()
    
    private let viewModel = ChatViewModel()
    
    var chatId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "FirstColor")
        
        setupViews()
        setupConstraints()
        setupTable()
        bind()
        
        viewModel.start(chatId: chatId)
    }
    
    private func setupViews() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Сообщение"
        
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(sendButton)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8)
        ])
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                let count = self?.viewModel.messages.count ?? 0
                if count > 0 {
                    let index = IndexPath(row: count - 1, section: 0)
                    self?.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc private func sendTapped() {
        viewModel.send(text: textField.text ?? "")
        textField.text = ""
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = viewModel.messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = message.text
        
        return cell
    }
}
