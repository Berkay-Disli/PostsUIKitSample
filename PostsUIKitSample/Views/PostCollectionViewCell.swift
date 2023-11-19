//
//  PostCollectionViewCell.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapLikeButton(for cell: PostCollectionViewCell)
}

class PostCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCollectionViewCell"
    private let LIKE_BUTTON_TAG = 3
    
    weak var delegate: PostCellDelegate? {
        didSet {
            print("DEBUG delegate set")
        }
    }

    var isLiked: Bool = false
    
    let userFirstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.anchor(width: 32, height: 32)
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    private var actionsView = PostActionsView(buttons: nil)
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "bubble.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private let repostButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "arrow.2.squarepath", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.isUserInteractionEnabled = true
        button.tag = LIKE_BUTTON_TAG
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(userFirstNameLabel)
        contentView.addSubview(profileImage)
        
        actionsView = PostActionsView(buttons: [commentButton, repostButton, likeButton, shareButton])
        contentView.addSubview(actionsView)
        contentView.addSubview(seperator)
    
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            userFirstNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            userFirstNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            
            contentLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timestampLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        actionsView.anchor(top: contentLabel.bottomAnchor, paddingTop: 4, height: 40)
        seperator.anchor(top: actionsView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 3, height: 0.7)
        
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
    }
    
    func configure(with content: Post, isLastItem: Bool = false) {
        let nameText = NSMutableAttributedString(string: content.userInfo.username, attributes: [.font:UIFont.systemFont(ofSize: 13, weight: .bold), .foregroundColor:UIColor.label])
        
        profileImage.sd_setImage(with: URL(string: content.userInfo.profileImageUrl))
        userFirstNameLabel.attributedText = nameText
        contentLabel.text = content.content
        timestampLabel.text = content.formattedDate
        
        actionsView.likeCountLabel.text = content.likes.count.description
        
        if let uid = DataManager.shared.userUID {
            isLiked = content.likes.contains(uid)
            let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = isLiked ? .red : .darkGray
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }


        // add one of these blocks for each button in our collection view cell we want to actually work
        if self.likeButton.point(inside: convert(point, to: likeButton), with: event) {
            return self.likeButton
        }

        return super.hitTest(point, with: event)
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG actually calling handleLikeTapped")
        delegate?.didTapLikeButton(for: self)
        
        isLiked = !isLiked
        
        UIView.animate(withDuration: 0.3) {
            self.updateLikeButtonAppearance()
        }
    }

    private func updateLikeButtonAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = isLiked ? .red : .darkGray
    }
}
