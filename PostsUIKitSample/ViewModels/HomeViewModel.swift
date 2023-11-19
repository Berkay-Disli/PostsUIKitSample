//
//  HomeViewModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import Foundation
import UIKit

class HomeViewModel {
    private let networkManager = NetworkManager.shared
    private let dataManager = DataManager.shared

    public var isNetworking: Bool = false

    var posts: [Post] = []
    
    func fetchPosts(completion: @escaping (Error?) -> Void) {
        dataManager.fetchPosts { [weak self] posts, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
            } else if let posts = posts {
                self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                completion(nil)
            }
        }
    }
    
    func createPost(content: String, completion: @escaping (Error?) -> Void) {
        dataManager.createPost(content: content) { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    
    func likePost(post: Post, completion: @escaping (Error?) -> Void) {
        dataManager.likePost(post: post) { error in
            completion(error)
        }
    }
    
    
    /*
    func likePost(post: Post, completion: @escaping (Error?) -> Void) {
        let isLiked = post.likes.contains(currentUser.uid)
        
        if isLiked {
            // User has already liked the post, remove their UID from likes
            post.likes.removeAll { $0 == currentUser.uid }
        } else {
            // User has not liked the post, add their UID to likes
            post.likes.append(currentUser.uid)
        }
        
        dataManager.likePost(post: post) { error in
            completion(error)
        }
    }
    */

    func numberOfItems() -> Int {
        return posts.count
    }

    func post(at index: Int) -> Post? {
        guard index < posts.count else {
            return nil
        }
        return posts[index]
    }
}

