//
//  NewChatCell.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 28.04.2026.
//

import UIKit

final class NewChatCell: UITableViewCell {
    
    static let identifier = "NewChatCell"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(birthdayLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            
            
            birthdayLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            birthdayLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            birthdayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
        
    }
    
    func configure(with user: ChatUser) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        birthdayLabel.text = formatDate(user.birthday)
        avatarImageView.image = user.avatar.image
    }

    private func formatDate(_ date: Date) -> String {
        return Self.dateFormatter.string(from: date)
    }
}
