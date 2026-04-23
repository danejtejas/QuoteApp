//
//  QuoteAppTests.swift
//  QuoteAppTests
//
//  Created by Tejas on 22/04/26.
//

import Testing
@testable import QuoteApp
import Foundation

struct User : Codable, Equatable {
    let id : Int
    let name : String
    
    static func getJsonData () throws -> Data {
        let users : [User] = [
            .init(id: 1, name: "Tejas"),
            .init(id: 2, name: "Om")
        ]
        return try JSONEncoder().encode(users)
    }
    
}

enum MockError : Error, Equatable {
    
    case badData
}

struct QuoteAppTests {

    @Test func testFetchUsersSucessAndReturnSucess() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
        
        let expectedUsers : [User] = [
            .init(id: 1, name: "Tejas"),
            .init(id: 2, name: "Om")
        ]
        
        MockURLProtocol.isSuccess = true
        MockURLProtocol.subbedData = try User.getJsonData()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let request = URLRequest(url: URL(string: "https://www.api.abc.com")!)
        
        
        let (data,response) = try await  session.data(for: request)
         
        guard let httpResponse  = response as? HTTPURLResponse else {
            #expect(Bool(false))
            return
        }
        
        let decodedUsers =  try JSONDecoder().decode([User].self, from: data)
    
        #expect(httpResponse.statusCode == 200)
        #expect(decodedUsers == expectedUsers)
        #expect(decodedUsers.first == expectedUsers.first)
    }

    @Test func testFetchUserErrorResturnError () async throws {
        let expectError = MockError.badData
        
        MockURLProtocol.isSuccess = false
        MockURLProtocol.subbedError = MockError.badData

        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let request = URLRequest(url: URL(string: "https://www.api.abc.com")!)
        do {
            let _ = try await session.data(for: request)
            #expect(Bool(false), "Expect to error bad")
        }
        catch  let error as MockError {
            #expect(error == .badData)
        }
        catch {
            #expect(Bool(false), "Wrong error type")
        }
    }
    
   
    
}



class MockURLProtocol : URLProtocol {
    
    static var subbedData : Data?
     
    static var isSuccess : Bool = true
    
    static var subbedError : Error?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    override func startLoading() {
        guard let response = HTTPURLResponse(
            url: request.url! ,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        
        client?
            .urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
        
        if MockURLProtocol.isSuccess {
            client?.urlProtocol(self, didLoad: MockURLProtocol.subbedData!)
        }
        else {
            if let error = MockURLProtocol.subbedError {
                
            
                client?
                    .urlProtocol(self, didFailWithError: MockError.badData)
            }
        }
        
        
        client?.urlProtocolDidFinishLoading(self)
        
        
    }
    
    override func stopLoading() {
        
    }
    
}
