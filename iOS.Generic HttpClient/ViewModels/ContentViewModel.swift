//
//  ContentViewModel.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 11.06.2024.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var users = [User]()
    
    private let userRepository: UserRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    /// better use `Swinject` for Dependency injection
    init() {
        self.userRepository = UserRepository(client: URLSession.shared)
    }
    
    func fetch() {
        userRepository.fetchUsers()
            .sink { data in
                if case .failure(let err) = data {
                    print(err)
                }
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellables)
    }
}
