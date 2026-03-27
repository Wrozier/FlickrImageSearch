//
//  FlickrFeed.swift
//  FlickrImageSearch
//
//  Created by William Rozier on 3/27/26.
//

import Foundation

struct FlickrFeed: Decodable {
    let items: [FlickrPhoto]
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
        tags.split(separator: " ").map(String.init)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, media, dateTaken = "date_taken", description, published, author, authorId = "author_id", tags
    }
}

struct Media: Decodable {
    let m: String
    
    
    var highResURL: URL? {
        URL(string: m.replacingOccurrences(of: "_m.", with: ".")) 
    }
}

