//
//  UserRepository.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 11.06.2024.
//

import Foundation
import Combine

enum RepositoryError: Error {
    case mapError
}

protocol UserRepositoryProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error>
}

final class UserRepository: UserRepositoryProtocol {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        do {
            let provider = try UserProvider.userList.makeRequest()
            return client.publisher(request: provider)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .tryMap(map)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// can be general mapping for regular cases
    private func map<T>(data: Data, response: HTTPURLResponse) throws -> T where T: Decodable {
        /// can handle specific http codes
        if (500...600).contains(response.statusCode) {
            throw RepositoryError.mapError
        }
        
        /// for decoder better use `ZippyJSON`
        return try JSONDecoder().decode(T.self, from: data)
    }
}
