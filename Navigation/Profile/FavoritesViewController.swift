//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    private let favoritesService: FavoritesService
    private var posts: [Post] = []
    private let tableView = UITableView()
    
    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "post")
        view.addSubview(tableView)
        
    }
    
    private func loadFavorites() {
        let savedPosts = favoritesService.fetchPosts()
        posts = savedPosts.map {
            Post(author: $0.author ?? "", description: $0.postDescription ?? "", image: $0.image ?? "", likes: Int($0.likes), views: Int($0.views))
        }
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configPostArray(post: post)
        
        return cell
    }
}

