//
//  FlickrFeed.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import Foundation


import Foundation

struct FlickrFeed: Decodable {
    let items: [FlickrPhoto]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct FlickrPhoto: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String?
    let description: String?
    let published: String?
    let author: String
    let authorId: String?
    let tags: String
    
    var tagList: [String] {
        tags.split(separator: " ").map(String.init).filter { !$0.isEmpty }
    }
    
    // Safer decoding with defaults
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorId = "author_id"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        media = try container.decode(Media.self, forKey: .media)
        dateTaken = try container.decodeIfPresent(String.self, forKey: .dateTaken)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        published = try container.decodeIfPresent(String.self, forKey: .published)
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? "Unknown"
        authorId = try container.decodeIfPresent(String.self, forKey: .authorId)
        tags = try container.decodeIfPresent(String.self, forKey: .tags) ?? ""
    }
}

struct Media: Decodable {
    let m: String
    
    var highResURL: URL? {
        let large = m
            .replacingOccurrences(of: "_m.jpg", with: ".jpg")
            .replacingOccurrences(of: "_m.png", with: ".png")
        return URL(string: large)
    }
}
