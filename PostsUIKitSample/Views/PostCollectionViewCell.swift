//
//  PostCollectionViewCell.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCollectionViewCell"

    let userFirstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
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
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
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
//        view.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(userFirstNameLabel)
        
        actionsView = PostActionsView(buttons: [commentButton, repostButton, likeButton, shareButton])
        contentView.addSubview(actionsView)
        contentView.addSubview(seperator)
        
        NSLayoutConstraint.activate([
            userFirstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userFirstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: userFirstNameLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        actionsView.anchor(top: bodyLabel.bottomAnchor, paddingTop: 4, height: 40)
        seperator.anchor(top: actionsView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 6, height: 0.85)
        
    }
    
    func configure(with content: (PostModel, UserModel), isLastItem: Bool = false) {
        let nameText = NSMutableAttributedString(string: content.1.name, attributes: [.font:UIFont.systemFont(ofSize: 13, weight: .bold), .foregroundColor:UIColor.label])
        let usernameText = NSAttributedString(string: "   @\(content.1.username)", attributes: [.font:UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor:UIColor.gray])
        nameText.append(usernameText)
        userFirstNameLabel.attributedText = nameText
        titleLabel.text = content.0.title
        bodyLabel.text = content.0.body
        
        if isLastItem {
            seperator.layer.opacity = 0
        }
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG like tapped")
    }
}
