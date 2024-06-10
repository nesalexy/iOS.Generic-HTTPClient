//
//  ContentType.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 10.06.2024.
//

import Foundation

enum ContentType {
    case json
    
    var key: String {
        "Content-Type"
    }
    
    var value: String {
        switch self {
        case .json:
            "application/json; charset=utf-8"
        }
    }
}
