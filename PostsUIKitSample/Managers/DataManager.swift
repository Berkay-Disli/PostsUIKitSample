//
//  DataManager.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 16.11.2023.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class DataManager {
    static let shared = DataManager()
    private var username: String = ""
    public var profileImageUrl: URL? = nil

    let db = Firestore.firestore()

    private init() {}
    
    func fetchUser(completion: @escaping (URL?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("DEBUG no current user!")
            return
        }
        
        let uid = currentUser.uid
        let reference = Storage.storage().reference().child("user-pp/\(uid).jpg")
        reference.downloadURL { url, err in
            guard err == nil else {
                print("DEBUG Error fetching download URL")
                return
            }
            
            if let url = url {
                self.profileImageUrl = url
                completion(url)
            } else {
                print("DEBUG cant unwrap optional URL")
            }
        }
    }

    func createPost(content: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("DEBUG no current user!")
            return
        }
        
        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG error in getting document for username: \(error)")
                completion(error)
            }
            
            if let username = snapshot?.get("username") as? String {
                self.username = username
            }
            
            let userInfo:[String:Any] = [
                "userId": currentUser.uid,
                "username": self.username,
                "profileImageUrl": self.profileImageUrl?.absoluteString ?? ""
            ]
            let post: [String:Any] = [
                "content": content,
                "timestamp": Date().description,
                "user-info": userInfo
            ]
            
            self.db.collection("posts").addDocument(data: post) { error in
                completion(error)
            }
        }
    }

    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }

            let posts = documents.compactMap { document -> Post? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                    let post = try JSONDecoder().decode(Post.self, from: jsonData)
                    return post
                } catch {
                    print("Error decoding post: \(error.localizedDescription)")
                    return nil
                }
            }

            completion(posts, nil)
        }
    }
}


