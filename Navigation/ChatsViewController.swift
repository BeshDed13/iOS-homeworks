//
//  ChatsViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class ChatsViewController: UIViewController {
    
    private let viewModel = ChatsViewModel()
    
    private let tableView = UITableView()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока пусто. Начните с кем-нибудь общение!"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "FirstColor")
        
        navigationItem.title = "Чаты"

        setupViews()
        setupConstraints()
        setupTableView()
        bind()
        setupRightBarButton()

        viewModel.startListening()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.viewModel.chats.isEmpty
            }
        }
    }
    
    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChat))
    }
    
    @objc private func addChat() {
        let vc = NewChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let chat = viewModel.chats[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = chat.lastMessage.isEmpty ? "Новый чат" : chat.lastMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = viewModel.chats[indexPath.row]
        
        let vc = ChatViewController()
        vc.chatId = chat.id
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
