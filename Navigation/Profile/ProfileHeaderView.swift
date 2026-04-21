//
//  ProfileHeaderView.swift
//  Navigation
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Callbacks
    
    var onAvatarExpand: (() -> Void)?
    var onAvatarCollapse: (() -> Void)?
    
    // MARK: - UI
    
    private let fullNameLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let statusLabel = UILabel()
    private let statusTextField = UITextField()
    private let setStatusButton = UIButton()
    private let returnAvatarButton = UIButton()
    private let avatarBackground = UIView()
    
    private var statusText = "Статус"
    private var avatarOriginPoint = CGPoint()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        
        statusTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubviews(
            avatarBackground,
            avatarImageView,
            fullNameLabel,
            statusLabel,
            statusTextField,
            setStatusButton,
            returnAvatarButton
        )
        
        fullNameLabel.font = .boldSystemFont(ofSize: 18)
        fullNameLabel.textColor = UIColor(named: "TextColor")
        
        statusLabel.font = .systemFont(ofSize: 17)
        statusLabel.textColor = UIColor(named: "TextColor")
        statusLabel.text = statusText
        
        statusTextField.textColor = UIColor(named: "TextColor")
        statusTextField.backgroundColor = UIColor(named: "FirstColor")
        statusTextField.layer.cornerRadius = 8
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.gray.cgColor
        statusTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        statusTextField.leftViewMode = .always
        statusTextField.attributedPlaceholder = NSAttributedString(
            string: "Ready...",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.layer.cornerRadius = LayoutConstants.cornerRadius
        setStatusButton.setTitle("Показать статус", for: .normal)
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        
        avatarImageView.image = UIImage(named: "teo")
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        avatarImageView.addGestureRecognizer(tap)
        
        returnAvatarButton.alpha = 0
        returnAvatarButton.setImage(
            UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
        
        avatarBackground.backgroundColor = .black
        avatarBackground.alpha = 0
        avatarBackground.isHidden = true
    }
    
    private func setupConstraints() {
        [
            avatarBackground,
            avatarImageView,
            fullNameLabel,
            statusLabel,
            statusTextField,
            setStatusButton,
            returnAvatarButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            avatarBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avatarBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalToConstant: 128),
            
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            statusTextField.heightAnchor.constraint(equalToConstant: 32),
            
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 48),
            
            returnAvatarButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            returnAvatarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with user: User) {
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
        avatarImageView.image = user.avatar
    }
    
    // MARK: - Actions
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    @objc private func statusButtonPressed() {
        statusLabel.text = statusText
    }
    
    @objc private func didTapOnAvatar() {
        avatarImageView.isUserInteractionEnabled = false
        onAvatarExpand?()
        
        avatarOriginPoint = avatarImageView.center
        let scale = UIScreen.main.bounds.width / avatarImageView.bounds.width
        
        avatarBackground.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.avatarBackground.alpha = 0.7
            self.avatarImageView.center = CGPoint(
                x: UIScreen.main.bounds.midX,
                y: UIScreen.main.bounds.midY - self.avatarOriginPoint.y
            )
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        UIView.animate(withDuration: 0.5) {
            self.returnAvatarButton.alpha = 0
            self.avatarImageView.center = self.avatarOriginPoint
            self.avatarImageView.transform = .identity
            self.avatarImageView.layer.cornerRadius = 64
            self.avatarBackground.alpha = 0
        } completion: { _ in
            self.avatarBackground.isHidden = true
            self.avatarImageView.isUserInteractionEnabled = true
            self.onAvatarCollapse?()
        }
    }
}

// MARK: - UITextFieldDelegate

extension ProfileHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
