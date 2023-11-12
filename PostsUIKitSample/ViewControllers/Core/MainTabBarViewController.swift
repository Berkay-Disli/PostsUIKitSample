//
//  MainTabBarViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
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
    
}
