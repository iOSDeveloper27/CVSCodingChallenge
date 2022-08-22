//
//  APIEndPoint.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation

typealias Headers = [String:String]
typealias Parameters = [String:Any]

protocol APIEndPoint {
    var headers : Headers { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var url: URL { get }
    var task: HTTPTask { get }
}

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?)
}

public enum HTTPErrors: Error {
    case noHttpScheme
    case nilData
    case decodingFailed
    case encodingFailed
}

extension HTTPErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noHttpScheme:
            return NSLocalizedString("Response is not of HTTP scheme", comment: "No HTTP scheme")
        case .nilData:
            return NSLocalizedString("There is no information at this URL", comment: "Nil Data")
        case .decodingFailed:
            return NSLocalizedString("Decoding has failed", comment: "Decoding Failed")
        case .encodingFailed:
            return NSLocalizedString("Encoding has failed", comment: "Encoding Failed")
        }
    }
}
