//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Abdelrahman Mohamed on 26.12.2024.
//

import XCTest
@testable import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSut()
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSut()
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSut()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSut()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSut()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSut()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyJSONList = Data("{\"items\":[]}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSONList)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithValidJSONList() {
        let (sut, client) = makeSut()
        
        let items: [FeedItem] = [
            .init(
                id: UUID(),
                description: nil,
                location: nil,
                imageURL: URL(string: "https://example.com")!
            ),
            .init(
                id: UUID(),
                description: "Good news",
                location: nil,
                imageURL: URL(string: "https://example.com")!
            ),
            .init(
                id: UUID(),
                description: nil,
                location: "Istanbul",
                imageURL: URL(string: "https://example.com")!
            ),
            .init(
                id: UUID(),
                description: "Umrah",
                location: "Mekkah",
                imageURL: URL(string: "https://example.com")!
            )
        ]
        
        let expectedItemJSON = [
            "items": items.map {
                [
                    "id": $0.id.uuidString,
                    "description": $0.description,
                    "location": $0.location,
                    "image": $0.imageURL.absoluteString
                ].compactMapValues { $0 }
            }
        ]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = try! JSONSerialization.data(
                withJSONObject: expectedItemJSON
            )
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        url: URL = URL(string: "https://example.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteFeedLoader,
        toCompleteWith result: RemoteFeedLoader.Result,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var capturedResults: [RemoteFeedLoader.Result] = []
        sut.load { capturedResults.append($0) }
        
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPCLientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(
            from url: URL,
            completion: @escaping (HTTPCLientResult) -> Void
        ) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}
