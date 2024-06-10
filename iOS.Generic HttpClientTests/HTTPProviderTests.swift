//
//  HTTPProviderTests.swift
//  iOS.Generic HttpClientTests
//
//  Created by Alexy Nesterchuk on 10.06.2024.
//

import XCTest
@testable import iOS_Generic_HttpClient

final class HTTPProviderTests: XCTestCase {}

// MARK: - Get users
extension HTTPProviderTests {
    func testUsersProvider_preparedData() throws {
        let provider = StubHTTPProvider.getUsers
        XCTAssertEqual(StubConstants.APIDetails.APIScheme, provider.scheme)
        XCTAssertEqual(StubConstants.APIDetails.APIHost, provider.host)
        XCTAssertEqual("users", provider.path)
        XCTAssertNil(provider.query)
        XCTAssertNil(provider.headers)
        XCTAssertEqual(HTTPMethod.GET.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNil(try provider.getData())
    }
    
    func testUsersProvider_makeRequest() throws {
        let provider = StubHTTPProvider.getUsers
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
        XCTAssertNil(request.httpBody)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        
        XCTAssertNil(request.httpBody)
    }
}

// MARK: - Get user
extension HTTPProviderTests {
    func testUserProvider_preparedData() throws {
        let userID = "1"
        let provider = StubHTTPProvider.getUser(id: userID)
        XCTAssertEqual(StubConstants.APIDetails.APIScheme, provider.scheme)
        XCTAssertEqual(StubConstants.APIDetails.APIHost, provider.host)
        XCTAssertEqual("users", provider.path)
        
        /// testing query
        let expectedQueryItems = [
            URLQueryItem(name: "userID", value: userID),
        ]
        XCTAssertEqual(provider.query?.count, expectedQueryItems.count)
        for (index, queryItem) in expectedQueryItems.enumerated() {
            XCTAssertEqual(provider.query?[index].name, queryItem.name)
            XCTAssertEqual(provider.query?[index].value, queryItem.value)
        }
        XCTAssertNil(provider.headers)
        XCTAssertEqual(HTTPMethod.GET.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNil(try provider.getData())
    }

    func testUserProvider_makeRequest() throws {
        let userID = "1"
        let provider = StubHTTPProvider.getUser(id: userID)
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users?userID=1"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
        XCTAssertNil(request.httpBody)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNil(request.httpBody)
    }
}


// MARK: - Helpers

struct StubConstants {
    struct APIDetails {
        static let APIScheme = "https"
        static let APIHost = "jsonplaceholder.typicode.com"
    }
}

struct MockUser: Encodable {
    let id: String
}

enum StubHTTPProvider: HTTPProvider {
    case getUsers
    case getUser(id: String)
    case createUser(user: MockUser)
    case deleteUser(id: String)
    case fullUpdateUser(id: String, user: MockUser)
    case partialUpgradeUser(id: String, user: MockUser)
}

extension StubHTTPProvider  {
    var scheme: String {
        StubConstants.APIDetails.APIScheme
    }
    
    var host: String {
        StubConstants.APIDetails.APIHost
    }
    
    var path: String? {
        switch self {
        case .getUser, .getUsers, .createUser, .deleteUser, .fullUpdateUser, .partialUpgradeUser:
            "users"
        }
    }
    
    var query: [URLQueryItem]? {
        var queryItems: [URLQueryItem]?
        
        switch self {
        case .getUser(let id):
            queryItems = [.init(name: "userID", value: id)]
        case .deleteUser(let id):
            queryItems = [.init(name: "userID", value: id)]
        case .fullUpdateUser(let id, _):
            queryItems = [.init(name: "userID", value: id)]
        case .partialUpgradeUser(let id, _):
            queryItems = [.init(name: "userID", value: id)]
        case .getUsers, .createUser:
            queryItems = nil
        }
        
        return queryItems
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var method: String {
        switch self {
        case .getUsers, .getUser:
            HTTPMethod.GET.rawValue
        case .createUser:
            HTTPMethod.POST.rawValue
        case .deleteUser:
            HTTPMethod.DELETE.rawValue
        case .fullUpdateUser:
            HTTPMethod.PATCH.rawValue
        case .partialUpgradeUser:
            HTTPMethod.PUT.rawValue
        }
    }
    
    var contentType: ContentType {
        ContentType.json
    }
    
    func getData() throws -> Data? {
        var data: Data?
        
        switch self {
        case .getUsers, .getUser, .deleteUser:
            data = nil
        case .createUser(let user):
            data = try JSONEncoder().encode(user)
        case .fullUpdateUser(_ , let user):
            data = try JSONEncoder().encode(user)
        case .partialUpgradeUser(_, let user):
            data = try JSONEncoder().encode(user)
        }
        
        return data
    }
}

