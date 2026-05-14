//
//  PhotosViewController.swift
//  Navigation
//

import UIKit
import PhotosUI

final class PhotosViewController: UIViewController {

    private let photoIdent = "photoCell"
    private let storage = PhotoStorageService()

    private var images: [UIImage] = []

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.register(PhotosCollectionViewCell.self,
                    forCellWithReuseIdentifier: photoIdent)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add,
                        target: self,
                        action: #selector(didTapAdd))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Галерея"
        view.backgroundColor = AppColors.firstBackground
        navigationItem.rightBarButtonItem = addButton
        
        collectionView.backgroundColor = AppColors.firstBackground

        view.addSubview(collectionView)
        setupConstraints()

        images = storage.loadAllImages()
        collectionView.reloadData()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapAdd() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension PhotosViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self,
                  let image = object as? UIImage else { return }

            DispatchQueue.main.async {
                if let _ = self.storage.save(image: image) {
                    self.images.append(image)
                    self.collectionView.reloadData()

                    let index = IndexPath(item: self.images.count - 1, section: 0)
                    self.collectionView.scrollToItem(at: index,
                                                     at: .bottom,
                                                     animated: true)
                }
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: photoIdent,
            for: indexPath
        ) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configCellCollection(photo: images[indexPath.item])
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let count: CGFloat = 2
        let spacing: CGFloat = 32
        let width = (collectionView.frame.width - spacing) / count

        return CGSize(width: width, height: width * 0.75)
    }
}
