//
//  Networking.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/17/22.
//

import Foundation
import UIKit

struct Networking {
    
    public static func callAPI<T: Codable>(api: APIEndPoint, type: T.Type) async throws -> T {
    
        let data = try await makeRequest(api: api)
        let decodedModel = try decode(data: data, type: T.self)
        return decodedModel
    }
    
    private static func makeRequest(api: APIEndPoint) async throws -> Data {
        var request = URLRequest(url: api.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = api.method.rawValue
        request.allHTTPHeaderFields = api.headers
        
        if case .requestParameters(let bodyParameters) = api.task, let bodyParameters = bodyParameters {
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted) else {
                throw HTTPErrors.encodingFailed
            }
            request.httpBody = jsonData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let _ = response as? HTTPURLResponse else {
            throw HTTPErrors.noHttpScheme
        }
        
        return data
    }
    
    private static func decode<T: Codable>(data: Data, type: T.Type) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        guard let decodedModel = try? jsonDecoder.decode(T.self, from: data) else {
            throw HTTPErrors.decodingFailed
        }
        
        return decodedModel
    }

    public static func downloadImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url, timeoutInterval: 30.0))
        
        guard let _ = response as? HTTPURLResponse else {
            throw HTTPErrors.noHttpScheme
        }
        
        guard let image = UIImage(data: data) else {
            throw HTTPErrors.nilData
        }
        
        return image
    }
}
