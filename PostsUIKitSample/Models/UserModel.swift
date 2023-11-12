//
//  UserModel.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import Foundation

struct UserModel: Codable {
    var id: Int
    var name, username, email: String
    var address: Address
    var phone, website: String
    var company: Company
}

struct Address: Codable {
    var street, suite, city, zipcode: String
    var geo: Geo
}

struct Geo: Codable {
    var lat, lng: String
}

struct Company: Codable {
    var name, catchPhrase, bs: String
}
