//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 22.11.2025.
//

import Foundation
import UIKit

class ProfileHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imageView")
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show status", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(usernameLabel)
        addSubview(subtitleLabel)
        addSubview(statusButton)
        
        statusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = 100
        imageView.frame = CGRect(
            x: 16,
            y: 16,
            width: size,
            height: size
        )
        
        imageView.layer.cornerRadius = size / 2
        
        usernameLabel.frame = CGRect(
            x: imageView.frame.maxX + 16,
            y: 27,
            width: frame.width - (imageView.frame.maxX + 16),
            height: 20
        )
        
        subtitleLabel.frame = CGRect(
            x: imageView.frame.maxX + 16,
            y: imageView.frame.maxY - 34,
            width: frame.width - (imageView.frame.maxX + 16),
            height: 20
        )
        
        statusButton.frame = CGRect(
            x: 16,
            y: imageView.frame.maxY + 16,
            width: frame.width - 32,
            height: 50
        )
     
    }
    
    @objc func buttonPressed() {
        print("\(subtitleLabel.text!)")
    }
}
