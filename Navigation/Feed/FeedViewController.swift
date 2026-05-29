//
//  FeedViewController.swift
//  Navigation
//

import UIKit

final class FeedViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    private let favoritesService = FavoritesService()
    
    private let viewModel = FeedViewModel()
    
    private var posts: [Post] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PostTableViewCell.self, forCellReuseIdentifier: "post")
        return table
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Лента"
        label.font = AppFonts.title
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.firstBackground
        
        navigationItem.titleView = titleLabel
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        bindViewModel()
        viewModel.fetchCats()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func bindViewModel() {

        viewModel.onPostsUpdated = { [weak self] in

            self?.tableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        
        cell.configPostArray(post: viewModel.posts[indexPath.row])
        
        cell.onLike = { [weak self] in
            guard let self = self else { return }
            
            viewModel.likePost(at: indexPath.row)
            
            do {
                try self.favoritesService.save(post: self.viewModel.posts[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to save post: \(error)")
            }
        }
        
        return cell
    }
}
