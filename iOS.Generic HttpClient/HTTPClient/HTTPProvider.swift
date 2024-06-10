//
//  HTTPProvaider.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 10.06.2024.
//

import Foundation


enum HTTPProviderError: Error {
    case urlGeneration
}

protocol HTTPProvider {
    var url: String { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var method: String { get }
    var contentType: ContentType  { get }
    var body: Data? { get }
}

extension HTTPProvider {
    
    func makeRequest() throws -> URLRequest {
        var request = URLRequest(url: try generateURL())
        request.httpMethod = method
        
        for headerItem in headers ?? [:] {
            request.setValue(headerItem.value, forHTTPHeaderField: headerItem.key)
        }
        
        request.setValue(contentType.value, forHTTPHeaderField: contentType.key)
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func generateURL() throws -> URL {
        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host = Constants.APIDetails.APIHost
        
        if let path = path {
            components.path = path
        }
        
        components.queryItems = query
        
        guard let url = components.url else {
            throw HTTPProviderError.urlGeneration
        }
        
        return url
    }
}
