//
//  ImageData.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

struct ImageData: Codable {
    
    struct Images: Codable {
        let fixedHeight: URL
        let original: URL
        
        enum CodingKeys: String, CodingKey {
            case fixedHeight = "fixed_height"
            case original
        }
        enum ImageKeys: CodingKey {
            case url
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let fixedHeighNested = try values.nestedContainer(keyedBy: ImageKeys.self, forKey: .fixedHeight)
            fixedHeight = try fixedHeighNested.decode(URL.self, forKey: .url)
            let originalHeighNested = try values.nestedContainer(keyedBy: ImageKeys.self, forKey: .original)
            original = try originalHeighNested.decode(URL.self, forKey: .url)
        }
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var fixedHeighNested = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .fixedHeight)
            try fixedHeighNested.encode(fixedHeight, forKey: .url)
            var originalHeighNested = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .original)
            try originalHeighNested.encode(original, forKey: .url)
        }
    }
    
    let id: String
    let url: URL
    let lastUpdated: Date?
    let created: Date?
    let user: User?
    let title: String?
    var images: Images
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case lastUpdated = "update_datetime"
        case created = "create_datetime"
        case user
        case title
        case images
    }
}
