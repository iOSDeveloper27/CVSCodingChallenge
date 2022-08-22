//
//  FlickrImage.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation

struct FlickrImage: Codable {
    
    let title: String
    let link: String
    let image: String
    let dateTaken: Date
    let description: String
    let published: Date
    let author: String
    let authorId: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, media, date_taken, description, published, author, author_id, tags
    }
    
    enum MediaCodingKeys: String, CodingKey {
        case m
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(String.self, forKey: .link)
        
        let mediaContainer = try container.nestedContainer(keyedBy: MediaCodingKeys.self, forKey: .media)
        image = try mediaContainer.decode(String.self, forKey: .m)
        
        dateTaken = try container.decode(Date.self, forKey: .date_taken)
        description = try container.decode(String.self, forKey: .description)
        published = try container.decode(Date.self, forKey: .published)
        author = try container.decode(String.self, forKey: .author)
        authorId = try container.decode(String.self, forKey: .author_id)
        tags = try container.decode(String.self, forKey: .tags)
    }
    
    public func encode(to encoder: Encoder) throws {}
}
