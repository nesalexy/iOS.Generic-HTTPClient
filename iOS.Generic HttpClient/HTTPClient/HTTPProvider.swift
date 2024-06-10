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
    var scheme: String { get }
    var host: String { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var method: String { get }
    var contentType: ContentType  { get }
    func getData() throws -> Data?
}

extension HTTPProvider {
    
    func makeRequest() throws -> URLRequest {
        var request = URLRequest(url: try generateURL())
        request.httpMethod = method
        
        for headerItem in headers ?? [:] {
            request.setValue(headerItem.value, forHTTPHeaderField: headerItem.key)
        }
        
        request.setValue(contentType.value, forHTTPHeaderField: contentType.key)
        
        if let body = try getData() {
            request.httpBody = body
        }
        
        return request
    }
    
    private func generateURL() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        
        if let path = path {
            components.path = path.hasPrefix("/") ? path : "/\(path)"
        }
        
        components.queryItems = query
        
        guard let url = components.url else {
            throw HTTPProviderError.urlGeneration
        }
        
        return url
    }
}


extension URLRequest {
    func getHeaderValue(forKey key: String) -> String? {
        return allHTTPHeaderFields?[key]
    }
}
