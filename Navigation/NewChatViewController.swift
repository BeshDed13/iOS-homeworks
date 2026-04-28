//
//  NewChatViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class NewChatViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private let viewModel = NewChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "FirstColor")

        searchBar.delegate = self
        setupViews()
        setupConstraints()
        setupTable()
        bind()

        viewModel.onChatCreated = { [weak self] chatId in
            let vc = ChatViewController()
            vc.chatId = chatId
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                ])
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewChatCell.self, forCellReuseIdentifier: NewChatCell.identifier)
        tableView.rowHeight = 70
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 74, bottom: 0, right: 12)
    }
    
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}

extension NewChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }
}

extension NewChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.users[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewChatCell.identifier,
            for: indexPath
            ) as? NewChatCell else {
            return UITableViewCell()
        }
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        viewModel.selectUser(user)
    }
}
