//
//  PostViewController.swift
//  Navigation
//

import UIKit

final class PostViewController: UIViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = post?.author ?? "-"
        view.backgroundColor = UIColor(named: "SecondColor")
        
        let barButton = UIBarButtonItem(title: "Инфо", style: .done, target: self, action: #selector(tapInfoButton))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func tapInfoButton() {
    }
}
