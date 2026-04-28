//
//  AvatarSelectionViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 23.04.2026.
//

import UIKit

final class AvatarSelectionViewController: UIViewController {
    
    private let avatars = Avatar.allCases
    private let completion: (Avatar) -> Void
    
    private var selectedIndexPath: IndexPath?
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let size = (UIScreen.main.bounds.width - 64) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        return cv
    }()
    
    // MARK: - Init
    
    init(completion: @escaping (Avatar) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AvatarSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AvatarCell",
            for: indexPath
        ) as? AvatarCell else {
            return UICollectionViewCell()
        }
        
        let avatar = avatars[indexPath.item]
        cell.configure(with: avatar)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let avatar = avatars[indexPath.item]
        
        selectedIndexPath = indexPath
        collectionView.reloadData()
        
        completion(avatar)
        
        dismiss(animated: true)
    }
}

final class AvatarCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with avatar: Avatar) {
        imageView.image = avatar.image
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected
            ? UIColor.systemGreen.cgColor
            : UIColor.clear.cgColor
        }
    }
}
