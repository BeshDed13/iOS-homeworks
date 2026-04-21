//
//  ProfileViewController.swift
//  Navigation
//

import UIKit

final class ProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    static let headerIdent = "header"
    static let photoIdent = "photo"
    
    private let viewModel = ProfileViewModel()
    
    private var user: User?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdent)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: photoIdent)
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        view.backgroundColor = .systemRed
        #else
        view.backgroundColor = .systemBackground
        #endif
        
        view.backgroundColor = UIColor(named: "FirstColor")
        
        navigationItem.title = "Профиль"
        
        setupViews()
        setupConstraints()
        setupTableView()
        fetchUser()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
    }
    
    private func fetchUser() {
        viewModel.fetchCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch user: \(error)")
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func reloadTableView() {
        fetchUser()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // только PhotosTableViewCell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.photoIdent,
            for: indexPath
        ) as! PhotosTableViewCell
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Self.headerIdent
        ) as! ProfileHeaderView
        
        if let user = user {
            headerView.configure(with: user)
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(PhotosViewController(), animated: true)
    }
}
