//
//  AuthViewModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 15.11.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class AuthViewModel {
    public var username: String = ""
    public var email: String = ""
    public var password: String = ""
    private var user: User? = nil
    
    //    public var isNetworking: Bool = false
    
    var isNetworkingDidChange: ((Bool) -> Void)?
    
    private var _isNetworking: Bool = false {
        didSet {
            isNetworkingDidChange?(_isNetworking)
        }
    }
    
    var isNetworking: Bool {
        return _isNetworking
    }
    
    
    /*
    func registerUser(image: UIImage? = nil, completion: @escaping (Bool) -> Void) {
        _isNetworking = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG error is \(error)")
                completion(false)
            }

            guard result?.user != nil else {
                completion(false)
                return
            }
            completion(true)
            
            if let image = image?.jpegData(compressionQuality: 0.5) {
                
            }
            
            self._isNetworking = false // Move inside the completion handler
        }
    }
    */
    
    private func storeUserInfo(userID: String, imageURL: String?) {
        // Store user information in the "users" collection in Firestore
        let user: [String: Any] = [
            "username": self.username,
            "email": self.email,
            "profileImageURL": imageURL ?? "",
            "dateCreated": Date()
        ]

        DataManager.shared.db.collection("users").document(userID).setData(user) { error in
            if let error = error {
                print("DEBUG Error storing user information: \(error.localizedDescription)")
            } else {
                print("DEBUG created user info in firestore")
            }
        }
    }
    
    func registerUser(image: UIImage? = nil, completion: @escaping (Bool) -> Void) {
        _isNetworking = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("DEBUG error is \(error)")
                completion(false)
                self._isNetworking = false
                return
            }

            guard let user = result?.user else {
                completion(false)
                self._isNetworking = false
                return
            }
            
            self.user = user
            
            // Upload profile image to Firebase Storage
            if let image = image?.jpegData(compressionQuality: 0.5),
               let uid = self.user?.uid {
                let reference = Storage.storage().reference().child("user-pp/\(uid).jpg")
                reference.putData(image, metadata: nil) { metadata, error in
                    guard error == nil else {
                        print("DEBUG Error uploading image: \(error?.localizedDescription ?? "No error description")")
                        completion(false)
                        return
                    }
                    reference.downloadURL { url, err in
                        guard err == nil else {
                            print("DEBUG Error fetching download URL")
                            return
                        }
                        
                        if let url = url {
                            self.storeUserInfo(userID: uid, imageURL: url.absoluteString)
                        } else {
                            print("DEBUG cant unwrap optional URL")
                        }
                    }
                }
                self._isNetworking = false
                completion(true)
            } else {
                print("DEBUG cant create jpegdata")
                self.storeUserInfo(userID: user.uid, imageURL: nil)
                self._isNetworking = false
                completion(true)
            }
        }
    }

    func loginUser(completion: @escaping (Bool) -> Void) {
        _isNetworking = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG error is \(error)")
                completion(false)
            }

            guard result?.user != nil else {
                completion(false)
                return
            }
            completion(true)
            self._isNetworking = false // Move inside the completion handler
        }
    }

    
    func signOut(completion: @escaping (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error {
            print("DEBUG signOut error: \(error)")
            completion(false)
        }
    }
    
    func checkIfCurrentUserExists(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
}
