//
//  UserExchange.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 11.06.2024.
//

import Foundation

struct Geo: Codable, Hashable {
    let lat: String
    let lng: String
}

struct Address: Codable, Hashable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Company: Codable, Hashable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
