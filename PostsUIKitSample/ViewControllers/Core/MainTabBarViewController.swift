//
//  MainTabBarViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController, SearchViewControllerDelegate, UINavigationControllerDelegate {
    
    private let authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVCMain = SearchViewController(authViewModel: authViewModel)
        searchVCMain.delegate = self
        let searchVC = UINavigationController(rootViewController: searchVCMain)
        let chatRoomVC = UINavigationController(rootViewController: ChatRoomsViewController())
        let notificationsVC = UINavigationController(rootViewController: NotificationsViewController())
        let directMessagesVC = UINavigationController(rootViewController: DirectMessagesViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        chatRoomVC.tabBarItem.image = UIImage(systemName: "mic")
        chatRoomVC.tabBarItem.selectedImage = UIImage(systemName: "mic.fill")
        
        notificationsVC.tabBarItem.image = UIImage(systemName: "bell")
        notificationsVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        
        directMessagesVC.tabBarItem.image = UIImage(systemName: "envelope")
        directMessagesVC.tabBarItem.selectedImage = UIImage(systemName: "envelope.fill")
        
        setViewControllers([homeVC, searchVC, chatRoomVC, notificationsVC, directMessagesVC], animated: true)
    }
    
    func didSignOut() {
        let loginVC = UINavigationController(rootViewController: LoginViewController(authViewModel: authViewModel))
        loginVC.modalPresentationStyle = .overFullScreen
        present(loginVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authViewModel.checkIfCurrentUserExists { exists in
            if !exists {
                let loginVC = UINavigationController(rootViewController: LoginViewController(authViewModel: self.authViewModel))
                loginVC.modalPresentationStyle = .overFullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
}
