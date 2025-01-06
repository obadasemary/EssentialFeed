//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Abdelrahman Mohamed on 06.01.2025.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in
            
        }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://example.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    // MARK: - Helpers

    private class URLSessionSpy: URLSession {
        var receivedURLs: [URL] = []
        
        override func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void
        ) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }
}
