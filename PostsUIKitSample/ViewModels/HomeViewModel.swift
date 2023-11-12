//
//  HomeViewModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import Foundation

class HomeViewModel {
    private let networkManager = NetworkManager.shared

    // Define a closure type for the completion handler when fetching data
    typealias PostCompletionHandler = (Result<[PostModel], APIError>) -> Void
    typealias UserCompletionHandler = (Result<[UserModel], APIError>) -> Void

    // Data source for the collection view
    public var isNetworking: Bool = false
    private var posts: [PostModel] = []
    private var users: [UserModel] = []

    // Fetch data from the API
    func fetchPosts(completion: @escaping PostCompletionHandler) {
        let urlString = "https://jsonplaceholder.typicode.com/posts"

        isNetworking = true
        networkManager.fetchData(urlString: urlString) { [weak self] (result: Result<[PostModel], APIError>) in
            switch result {
            case .success(let data):
                self?.posts = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            self?.isNetworking = false
        }
    }
    
    func fetchUsers(completion: @escaping UserCompletionHandler) {
        let urlString = "https://jsonplaceholder.typicode.com/users"

        isNetworking = true
        networkManager.fetchData(urlString: urlString) { [weak self] (result: Result<[UserModel], APIError>) in
            switch result {
            case .success(let data):
                self?.users = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            self?.isNetworking = false
        }
    }

    func numberOfItems() -> Int {
        return posts.count
    }
    
    func postWithUsers(at index: Int) -> (PostModel, UserModel)? {
        guard index < posts.count else {
            return nil
        }
        let post = self.posts[index]
        guard let user = self.users.first(where: { $0.id == post.userId }) else {
            return nil
        }
        let response = (post, user)
        return response
    }

    func post(at index: Int) -> PostModel? {
        guard index < posts.count else {
            return nil
        }
        return posts[index]
    }
}

