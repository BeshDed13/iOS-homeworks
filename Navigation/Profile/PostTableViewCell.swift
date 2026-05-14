//
//  PostTableViewCell.swift
//  Navigation
//

import UIKit
import Kingfisher

final class PostTableViewCell: UITableViewCell {

    var onLike: (() -> Void)?

    private let postAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.body
        label.numberOfLines = 2
        return label
    }()

    private let postImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = AppColors.secondBackground
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private let postDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.body
        label.numberOfLines = 0
        return label
    }()

    private let postLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.body
        return label
    }()

    private let postViews: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.body
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = AppColors.secondBackground

        contentView.addSubviews(
            postAuthor,
            postImage,
            postDescription,
            postLikes,
            postViews
        )

        setupConstraints()
        setupGesture()

        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        postImage.kf.cancelDownloadTask()
        postImage.image = nil
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            postAuthor.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: LayoutConstants.indent
            ),

            postAuthor.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstants.leadingMargin
            ),

            postAuthor.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: LayoutConstants.trailingMargin
            ),

            postImage.topAnchor.constraint(
                equalTo: postAuthor.bottomAnchor,
                constant: LayoutConstants.indent
            ),

            postImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            postImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            postImage.heightAnchor.constraint(
                equalTo: postImage.widthAnchor,
                multiplier: 0.56
            ),

            postDescription.topAnchor.constraint(
                equalTo: postImage.bottomAnchor,
                constant: LayoutConstants.indent
            ),

            postDescription.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstants.leadingMargin
            ),

            postDescription.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: LayoutConstants.trailingMargin
            ),

            postLikes.topAnchor.constraint(
                equalTo: postDescription.bottomAnchor,
                constant: LayoutConstants.indent
            ),

            postLikes.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstants.leadingMargin
            ),

            postLikes.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -LayoutConstants.indent
            ),

            postViews.topAnchor.constraint(
                equalTo: postDescription.bottomAnchor,
                constant: LayoutConstants.indent
            ),

            postViews.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: LayoutConstants.trailingMargin
            ),

            postViews.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -LayoutConstants.indent
            )
        ])
    }

    private func setupGesture() {

        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )

        doubleTap.numberOfTapsRequired = 2

        contentView.addGestureRecognizer(doubleTap)
    }

    func configPostArray(post: Post) {

        postAuthor.text = post.author
        postDescription.text = post.description

        if let url = URL(string: post.image) {

            postImage.kf.setImage(
                with: url
            )
        }

        postLikes.attributedText = makeIconText(
            systemName: "heart.fill",
            text: "\(post.likes)"
        )

        postViews.attributedText = makeIconText(
            systemName: "eye.fill",
            text: "\(post.views)"
        )
    }

    @objc private func handleDoubleTap() {
        onLike?()
    }

    private func makeIconText(
        systemName: String,
        text: String
    ) -> NSAttributedString {

        let attachment = NSTextAttachment()

        attachment.image = UIImage(systemName: systemName)

        let icon = NSAttributedString(
            attachment: attachment
        )

        let value = NSAttributedString(
            string: " \(text)"
        )

        let result = NSMutableAttributedString()

        result.append(icon)
        result.append(value)

        return result
    }
}
