//
//  PostModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import Foundation

struct PostModel: Codable {
    var userId, id: Int
    var title, body: String
}
