//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Abdelrahman Mohamed on 26.12.2024.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSut()
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSut()
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLCallCount, 2)
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        url: URL = URL(string: "https://example.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLCallCount: Int = 0
        var requestedURLs: [URL] = [URL]()
        
        func get(from url: URL) {
            requestedURLCallCount += 1
            requestedURL = url
            requestedURLs.append(url)
        }
    }
    
    
}
