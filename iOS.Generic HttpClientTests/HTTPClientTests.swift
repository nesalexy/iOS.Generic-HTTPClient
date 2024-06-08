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

    var cancellables = Set<AnyCancellable>()
}

// MARK: - Testing Combine
extension HTTPClientTests {
    
    func testPublisher_DataNotNil_ResponseNotNil() {
        /// Arrange
        let url = URL(string: "https://test.com")!
        URLRequestSpyProtocol.requestHandler = { request in
            (HTTPURLResponse(url: url,
                            statusCode: 200,
                            httpVersion: nil,
                            headerFields: nil)!,
             Data())
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLRequestSpyProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
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
                let data = result.0
                let response = result.1
                
                XCTAssertNotNil(data)
                XCTAssertNotNil(response)
            }
            .store(in: &cancellables)
        
        /// Assert
        wait(for: [expectation], timeout: 1)
    }
    
    func testPublisher_DataNotNil_ResponseNil() {
        /// Arrange
        let url = URL(string: "https://test.com")!
        URLRequestSpyProtocol.requestHandler = { request in
            (nil, Data())
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLRequestSpyProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
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
        
        /// Assert
        wait(for: [expectation], timeout: 1)
    }
    
}
