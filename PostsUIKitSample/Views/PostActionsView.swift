//
//  PostActionsView.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

class PostActionsView: UIView {
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()

    init(buttons: [UIButton]?) {
        super.init(frame: .zero)
        
        configureUI(buttons: buttons)
    }
    
    private func configureUI(buttons: [UIButton]?) {
        frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        addSubview(stackView)
        stackView.frame = bounds
        if let buttons {
            for button in buttons {
                
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handle() {
        print("DEBUG like")
    }
}
