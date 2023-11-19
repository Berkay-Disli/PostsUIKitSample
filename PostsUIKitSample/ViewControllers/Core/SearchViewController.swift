//
//  SearchViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSignOut()
}

class SearchViewController: UIViewController {
    private let signOutButton = CustomBigButton(bgColor: .systemGreen, color: .label, title: "Sign Out", cornerStyle: .small)
  
    private let authViewModel: AuthViewModel
    
    weak var delegate: SearchViewControllerDelegate?
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(signOutButton)
        signOutButton.center(inView: view)
        signOutButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 55)
        signOutButton.addTarget(self, action: #selector(dismissToAuthFlow), for: .touchUpInside)
    }
    
    @objc func dismissToAuthFlow() {
        authViewModel.signOut { success in
            if success {
                /*
                let loginVC = UINavigationController(rootViewController: LoginViewController(authViewModel: self.authViewModel))
                loginVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(loginVC, animated: true)
                 */
                print("DEBUG should sign out now...")
                self.delegate?.didSignOut()
            }
        }
    }
}
