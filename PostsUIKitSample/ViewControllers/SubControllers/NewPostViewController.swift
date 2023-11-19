//
//  NewPostViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 16.11.2023.
//

import UIKit
import MultilineTextField
import SDWebImage

class NewPostViewController: UIViewController {
    var onPostCreated: (() -> Void)?
    
    private let cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Send Post", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        button.setAttributedTitle(title, for: .normal)
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.baseForegroundColor = .label
         return button
    }()
    
    private let profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postContentTextField: MultilineTextField = {
        let textField = MultilineTextField()
        textField.placeholder = "What's happening?"
        textField.placeholderColor = .systemGray
        textField.isPlaceholderScrollEnabled = true
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileImage.sd_setImage(with: DataManager.shared.profileImageUrl)
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(postButton)
        postButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingRight: 16)
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        view.addSubview(profileImage)
        profileImage.anchor(top: cancelButton.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 34, height: 34)
        profileImage.layer.cornerRadius = 34 / 2
       
        view.addSubview(postContentTextField)
        postContentTextField.anchor(top: postButton.bottomAnchor, left: profileImage.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 18, paddingLeft: 16, paddingBottom: 100, paddingRight: 16)
    }
 
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc func postButtonTapped() {
        DataManager.shared.createPost(content: postContentTextField.text) { error in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "An error occurred: \(error.localizedDescription)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                // Present the alert on the current view controller
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.onPostCreated?()
                self.dismiss(animated: true)
            }
        }
    }
}
