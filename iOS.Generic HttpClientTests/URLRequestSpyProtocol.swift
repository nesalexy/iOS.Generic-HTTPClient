//
//  URLRequestSpyProtocol.swift
//  iOS.Generic HttpClientTests
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

import XCTest
@testable import iOS_Generic_HttpClient


final class URLRequestSpyProtocol: URLProtocol {
    static var capturedRequest: URLRequest?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = URLRequestSpyProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            URLRequestSpyProtocol.capturedRequest = request
            
            let (response, data) = try handler(request)
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

