//
//  PostViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 08.11.2025.
//

import Foundation
import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "info", style: .plain, target: self, action: #selector(openInfo))
        
        
    }
    @objc func openInfo() {
        let vc = InfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
