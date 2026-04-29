//
//  ChatCell.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 23.04.2026.
//

import UIKit

final class ChatCell: UITableViewCell {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .lightGray
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        
        statusView.layer.cornerRadius = 5
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusView)
    }
    
    private func layout() {
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            messageLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            statusView.widthAnchor.constraint(equalToConstant: 10),
            statusView.heightAnchor.constraint(equalToConstant: 10),
            statusView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor)
        ])
    }
    
    func configure(with item: ChatItem) {
        
        nameLabel.text = item.name
        messageLabel.text = item.lastMessage
        
        avatarImageView.image = UIImage(named: item.avatarId)
        
        dateLabel.text = formatDate(item.date)
        
        statusView.backgroundColor = item.isOnline ? .green : .lightGray
    }
    
    private func formatDate(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Вчера"
        } else {
            formatter.dateFormat = "dd.MM"
        }
        
        return formatter.string(from: date)
    }
}
