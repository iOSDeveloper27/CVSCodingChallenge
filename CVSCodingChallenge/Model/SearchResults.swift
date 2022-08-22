//
//  SearchResults.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation

struct SearchResults: Codable {
    let title: String
    let link: String
    let modified: Date
    let generator: String
    let items: [FlickrImage]
}
