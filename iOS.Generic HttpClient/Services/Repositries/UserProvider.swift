//
//  UserProvider.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 11.06.2024.
//

import Foundation

enum UserProvider {
    case userList
}

extension UserProvider: HTTPProvider {
    var scheme: String {
        Constants.APIDetails.APIScheme
    }
    
    var host: String {
        Constants.APIDetails.APIHost
    }
    
    var path: String? {
        "users"
    }
    
    var query: [URLQueryItem]? { nil }
    
    var headers: [String : String]? { nil }
    
    var method: String {
        switch self {
        case .userList:
            HTTPMethod.GET.rawValue
        }
    }
    
    var contentType: ContentType {
        .json
    }
    
    func getData() throws -> Data? { nil }
}
