//
//  ProfileHeaderView.swift
//  Navigation
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    private let avatarImageView = UIImageView()
    private let fullNameLabel = UILabel()
    private let statusLabel = UILabel()
    private let birthDateLabel = UILabel()
    private let genderLabel = UILabel()
    
    private let mainStack = UIStackView()
    private let infoStack = UIStackView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        contentView.backgroundColor = UIColor(named: "FirstColor")
        
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        
        fullNameLabel.font = .boldSystemFont(ofSize: 18)
        fullNameLabel.textColor = UIColor(named: "TextColor")
        
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.textColor = .gray
        
        birthDateLabel.font = .systemFont(ofSize: 15)
        birthDateLabel.textColor = .darkGray
        
        genderLabel.font = .systemFont(ofSize: 15)
        genderLabel.textColor = .darkGray
    
        infoStack.axis = .vertical
        infoStack.spacing = 6
        
        infoStack.addArrangedSubview(fullNameLabel)
        infoStack.addArrangedSubview(statusLabel)
        infoStack.addArrangedSubview(birthDateLabel)
        infoStack.addArrangedSubview(genderLabel)
        
        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.alignment = .top
        
        mainStack.addArrangedSubview(avatarImageView)
        mainStack.addArrangedSubview(infoStack)
        
        contentView.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        [mainStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalToConstant: 128)
        ])
    }
    
    func configure(with user: User) {
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
        
        birthDateLabel.text = formatDate(user.birthday!)
        genderLabel.text = formatGender(user.gender)
        
        avatarImageView.image = UIImage(named: user.avatarId)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Дата рождения: \(formatter.string(from: date))"
    }
    
    private func formatGender(_ gender: String) -> String {
        let value = gender == "male" ? "Мужской" : "Женский"
        return "Пол: \(value)"
    }
}
