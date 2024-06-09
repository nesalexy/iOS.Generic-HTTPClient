//
//  HTTPClient.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

import Foundation
import Combine

enum HTTPClientError: Error {
    case httpCastingError
    case dataError
}

/// support Combine, Swift Concurrency, Closure
protocol HTTPClient {
    func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error>
    func data(request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
    func make(request: URLRequest, _ completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ())
}


extension URLSession: HTTPClient  {
    func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error> {
        dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw HTTPClientError.httpCastingError
                }
                
                return (data: result.data, response: httpResponse)
            }
            .eraseToAnyPublisher()
    }
    
    func data(request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let result = try await data(for: request)
        let response = result.1
        let data = result.0
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.httpCastingError
        }
        return (data: data, response: httpResponse)
    }
    
    func make(request: URLRequest, _ completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
        dataTask(with: request) { data, response, error in
            var result: (Result<(Data, HTTPURLResponse), Error>)
            
            defer {
                completion(result)
            }
            
            if let error = error {
                result = .failure(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                result = .failure(HTTPClientError.httpCastingError)
                return
            }
            
            guard let unwrappedData = data else {
                result = .failure(HTTPClientError.dataError)
                return
            }
            
            result = .success((unwrappedData, httpResponse))
        }
        .resume()
    }
    
}

