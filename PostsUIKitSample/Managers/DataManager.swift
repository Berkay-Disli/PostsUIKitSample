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
    public var userUID: String? = nil
    public var profileImageUrl: URL? = nil

    let db = Firestore.firestore()

    private init() {}
    
    func fetchUser(completion: @escaping (URL?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("DEBUG no current user!")
            return
        }
        
        let uid = currentUser.uid
        self.userUID = uid
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
    
    func likePost(post: Post, completion: @escaping (Error?) -> Void) {
        let postDocumentRef = db.collection("posts").document(post.documentId)
        guard let currentUser = Auth.auth().currentUser else {
            print("DEBUG no current user!")
            return
        }
        let uid = currentUser.uid

        let isLiked = post.likes.contains(uid)

        if isLiked {
            postDocumentRef.updateData(["likes": FieldValue.arrayRemove([uid])]) { error in
                completion(error)
            }
        } else {
            postDocumentRef.updateData(["likes": FieldValue.arrayUnion([uid])]) { error in
                completion(error)
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
            
            guard let username = snapshot?.get("username") as? String else {
                print("DEBUG username not found")
                completion(nil)
                return
            }
            
            let userInfo: [String: Any] = [
                "userId": currentUser.uid,
                "username": username,
                "profileImageUrl": self.profileImageUrl?.absoluteString ?? ""
            ]
            
            let ref = self.db.collection("posts").document()
            let refID = ref.documentID
            
            let post: [String: Any] = [
                "documentId": refID,
                "content": content,
                "timestamp": Date().description,
                "user-info": userInfo,
                "likes": []
            ]
            
            ref.setData(post) { error in
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


