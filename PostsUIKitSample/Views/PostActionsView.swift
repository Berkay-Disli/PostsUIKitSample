//
//  PostActionsView.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

class PostActionsView: UIView {
    private let LIKE_BUTTON_TAG = 3
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(buttons: [UIButton]?) {
        super.init(frame: .zero)
        
        configureUI(buttons: buttons)
    }
    
    private func configureUI(buttons: [UIButton]?) {
        frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        addSubview(stackView)
        addSubview(likeCountLabel)
        
        stackView.frame = bounds
        if let buttons {
            for button in buttons {
                stackView.addArrangedSubview(button)
            }
        }
        
        likeCountLabel.centerY(inView: stackView)
        likeCountLabel.anchor(right: stackView.rightAnchor, paddingRight: 125)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
