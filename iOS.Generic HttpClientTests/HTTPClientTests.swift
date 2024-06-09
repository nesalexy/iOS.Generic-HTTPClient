//
//  HTTPClientTests.swift
//  iOS.Generic HttpClientTests
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

@testable import iOS_Generic_HttpClient
import XCTest
import Combine

final class HTTPClientTests: XCTestCase {
    let url = URL(string: "https://test.com")!
    var cancellables = Set<AnyCancellable>()
}

// MARK: - Testing Combine
extension HTTPClientTests {
    
    func testPublisher_DataNotNil_ResponseNotNil() {
        /// Arrange
        let url = URL(string: "https://test.com")!
        let urlSession = makeSession(with: (HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)!,
                                            Data()))
        
        let expectation = XCTestExpectation(description: "Request by Combine with expected Data")
        
        /// Act
        urlSession.publisher(request: URLRequest(url: url))
            .sink { data in
                if case .failure(let error) = data {
                    /// Assert
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            } receiveValue: { result in
                XCTAssertNotNil(result.data)
                XCTAssertNotNil(result.response)
            }
            .store(in: &cancellables)
        
        /// Assert
        wait(for: [expectation], timeout: 1)
    }
    
    func testPublisher_DataNotNil_ResponseNil() {
        /// Arrange
        let urlSession = makeSession(with: (nil, Data()))
        
        let expectation = XCTestExpectation(description: "Request by Combine with expected Response error")
        
        /// Act
        urlSession.publisher(request: URLRequest(url: url))
            .sink { data in
                if case .failure(let error) = data {
                    /// Assert
                    XCTAssertNotNil(error)
                }
                expectation.fulfill()
            } receiveValue: {_ in }
            .store(in: &cancellables)
        
        /// Assert
        wait(for: [expectation], timeout: 1)
    }
    
    func testPublisher_CheckStatusCode() {
        /// Arrange
        let urlSession = makeSession(with: (HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)!,
                                            Data()))
        
        let expectation = XCTestExpectation(description: "Request by Combine check status code")
        
        /// Act
        urlSession.publisher(request: URLRequest(url: url))
            .sink { _ in
            } receiveValue: { result in
                XCTAssertEqual(result.response.statusCode, 200)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        /// Assert
        wait(for: [expectation], timeout: 1)
    }
    
}

// MARK: - Testing Swift Concurrency
extension HTTPClientTests {
    
    func testSwiftConcurrency_DataNotNil_ResponseNotNil() async throws {
        let urlSession = makeSession(with: (HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)!,
                                            Data()))
        
        let result = try await urlSession.data(request: URLRequest(url: url))
        XCTAssertNotNil(result.data)
        XCTAssertNotNil(result.response)
    }
    
    
    func testSwiftConcurrency_CheckStatusCode() async throws {
        let urlSession = makeSession(with: (HTTPURLResponse(url: url,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)!,
                                            Data()))
        
        let result = try await urlSession.data(request: URLRequest(url: url))
        XCTAssertEqual(200, result.response.statusCode)
    }
}

// MARK: - Helpers
extension HTTPClientTests {
    func makeSession(with response: (HTTPURLResponse?, Data)) -> URLSession {
        URLRequestSpyProtocol.requestHandler = { request in
            response
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLRequestSpyProtocol.self]
        return URLSession(configuration: configuration)
    }
}
