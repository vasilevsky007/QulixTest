//
//  User.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

struct User: Codable, Equatable {
    let avatar: URL
    let profileURL: URL
    let username: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case avatar = "avatar_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
    }
}
