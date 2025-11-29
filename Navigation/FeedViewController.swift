//
//  FeedViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 08.11.2025.
//

import Foundation
import UIKit

struct Post {
    let title: String
}

class FeedViewController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Feed"
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(openPost), for: .touchUpInside)
    }
    
    @objc func openPost() {
        let post = Post(title: "Hello, world!")
        UserDefaults.standard.set(post.title, forKey: "postTitle")
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
