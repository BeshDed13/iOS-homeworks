//
//  ProfileViewController.swift
//  Navigation
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    private let storage = PhotoStorageService()
    private var photos: [UIImage] = []
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.font = AppFonts.title
        label.textAlignment = .left
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        photos = storage.loadAllImages()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = AppColors.firstBackground
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
        
        setupViews()
        setupConstraints()
        setupTableView()
        fetchUser()
    }
    
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
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            self?.logout()
        }))
        
        present(alert, animated: true)
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            print("logout success")
            coordinator?.didLogout()
        } catch {
            print("Logout error:", error)
        }
    }
    
    @objc private func reloadTableView() {
        fetchUser()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func didTapLogout() {
        showLogoutAlert()
    }
    
    @objc private func didTapSettings() {
        coordinator?.openSettings()
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.photoIdent,
            for: indexPath
        ) as? PhotosTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: photos)

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
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(PhotosViewController(), animated: true)
    }
}
