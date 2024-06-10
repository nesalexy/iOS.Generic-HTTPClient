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
    func testUsersProvider_preparedData_GET() throws {
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
    
    func testUsersProvider_makeRequest_GET() throws {
        let provider = StubHTTPProvider.getUsers
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
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
    func testUserProvider_preparedData_GET() throws {
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

    func testUserProvider_makeRequest_GET() throws {
        let userID = "1"
        let provider = StubHTTPProvider.getUser(id: userID)
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users?userID=1"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNil(request.httpBody)
    }
}

// MARK: - Create user
extension HTTPProviderTests {
    func testUserProvider_preparedData_CREATE() throws {
        let mockUser = MockUser(id: "1")
        let provider = StubHTTPProvider.createUser(user: mockUser)
        
        XCTAssertEqual(StubConstants.APIDetails.APIScheme, provider.scheme)
        XCTAssertEqual(StubConstants.APIDetails.APIHost, provider.host)
        XCTAssertEqual("users", provider.path)
        XCTAssertNil(provider.query)
        XCTAssertNil(provider.headers)
        XCTAssertEqual(HTTPMethod.POST.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNotNil(try provider.getData())
    }

    func testUserProvider_makeRequest_CREATE() throws {
        let mockUser = MockUser(id: "1")
        let request = try StubHTTPProvider.createUser(user: mockUser).makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.POST.rawValue)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNotNil(request.httpBody)
    }
}

// MARK: - Delete user
extension HTTPProviderTests {
    func testUserProvider_preparedData_DELETE() throws {
        let userID = "1"
        let provider = StubHTTPProvider.deleteUser(id: userID)
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
        XCTAssertEqual(HTTPMethod.DELETE.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNil(try provider.getData())
    }

    func testUserProvider_makeRequest_DELETE() throws {
        let userID = "1"
        let provider = StubHTTPProvider.deleteUser(id: userID)
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users?userID=1"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.DELETE.rawValue)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNil(request.httpBody)
    }
}

// MARK: - PUT user
extension HTTPProviderTests {
    func testUserProvider_preparedData_PUT() throws {
        let userID = "1"
        let provider = StubHTTPProvider.fullUpdateUser(id: userID,
                                                           user: .init(id: userID, name: "Test"))
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
        XCTAssertEqual(HTTPMethod.PUT.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNotNil(try provider.getData())
    }

    func testUserProvider_makeRequest_PUT() throws {
        let userID = "1"
        let provider = StubHTTPProvider.fullUpdateUser(id: userID,
                                                           user: .init(id: userID, name: "Test"))
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users?userID=1"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.PUT.rawValue)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNotNil(request.httpBody)
    }
}

// MARK: - PATCH user
extension HTTPProviderTests {
    func testUserProvider_preparedData_PATCH() throws {
        let userID = "1"
        let provider = StubHTTPProvider.partialUpgradeUser(id: userID,
                                                           user: .init(id: userID, name: "Test"))
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
        XCTAssertEqual(HTTPMethod.PATCH.rawValue, provider.method)
        XCTAssertEqual(ContentType.json, provider.contentType)
        XCTAssertNotNil(try provider.getData())
    }

    func testUserProvider_makeRequest_PATCH() throws {
        let userID = "1"
        let provider = StubHTTPProvider.partialUpgradeUser(id: userID,
                                                           user: .init(id: userID, name: "Test"))
        let request = try provider.makeRequest()
        
        let expectedAbsoluteString = "\(StubConstants.APIDetails.APIScheme)://\(StubConstants.APIDetails.APIHost)/users?userID=1"
        XCTAssertEqual(expectedAbsoluteString, request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, HTTPMethod.PATCH.rawValue)
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 1)
        
        if let contentTypeValue = request.allHTTPHeaderFields?[ContentType.json.key] {
            XCTAssertEqual(ContentType.json.value, contentTypeValue)
        } else {
            XCTFail("The Content-Type header is missing")
        }
        XCTAssertNotNil(request.httpBody)
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
    var name: String?
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
            HTTPMethod.PUT.rawValue
        case .partialUpgradeUser:
            HTTPMethod.PATCH.rawValue
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

