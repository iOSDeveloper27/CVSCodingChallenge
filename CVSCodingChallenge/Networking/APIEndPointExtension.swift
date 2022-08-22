//
//  APIEndPointExtension.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation

extension APIEndPoint {
    var headers: [String:String] {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
}
