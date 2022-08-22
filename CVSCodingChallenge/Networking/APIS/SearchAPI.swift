//
//  SearchAPI.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation

struct SearchAPI: APIEndPoint {
    
    private(set) var path = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    private(set) var task: HTTPTask = .request
    private(set) var method: HTTPMethod = .get
    private(set) var url: URL
    
    init(_ searchText:String) {
        
        url = URL(string: path + searchText)!
    }
}
