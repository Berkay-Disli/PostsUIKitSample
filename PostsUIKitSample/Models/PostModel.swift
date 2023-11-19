//
//  PostModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import Foundation
import Firebase

struct Post: Codable {
    let userInfo: UserInfoModel
    let content: String
    let timestamp: String
    
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = dateFormatter.date(from: timestamp) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
                return "Today, \(dateFormatter.string(from: date))"
            } else if Calendar.current.isDateInYesterday(date) {
                dateFormatter.dateFormat = "HH:mm"
                return "Yesterday, \(dateFormatter.string(from: date))"
            } else {
                dateFormatter.dateFormat = "dd MMM"
                return dateFormatter.string(from: date)
            }
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case userInfo = "user-info"
        case content
        case timestamp
    }
    
}

struct UserInfoModel: Codable {
    let profileImageUrl: String
    let username: String
    let userId: String
}
