//
//  ImageData.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

struct ImageData: Decodable, Equatable {
    
    struct Images: Decodable, Equatable {
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
    let imported: Date?
    let user: User?
    let title: String?
    var images: Images
    
    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(URL.self, forKey: .url)
        let lastUpdatedString = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
        if let lastUpdatedString = lastUpdatedString {
            self.lastUpdated = dateFormatter.date(from: lastUpdatedString)
        } else {
            self.lastUpdated = nil
        }
        let createdString = try container.decodeIfPresent(String.self, forKey: .created)
        if let createdString = createdString {
            self.created = dateFormatter.date(from: createdString)
        } else {
            self.created = nil
        }
        let importedString = try container.decodeIfPresent(String.self, forKey: .imported)
        if let importedString = importedString {
            self.imported = dateFormatter.date(from: importedString)
        } else {
            self.imported = nil
        }
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.images = try container.decode(ImageData.Images.self, forKey: .images)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case lastUpdated = "update_datetime"
        case created = "create_datetime"
        case imported = "import_datetime"
        case user
        case title
        case images
    }
}
