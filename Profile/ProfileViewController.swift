//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 22.11.2025.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    private let headerView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        view.addSubview(headerView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews( )
        headerView.frame = view.bounds
    }
    
}
