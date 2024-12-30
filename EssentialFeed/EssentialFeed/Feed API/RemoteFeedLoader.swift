//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 26.12.2024.
//

import Foundation

public enum HTTPCLientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(
        from url: URL,
        completion: @escaping (HTTPCLientResult) -> Void
    )
}

public final class RemoteFeedLoader {
    
    let url: URL
    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(
        url: URL,
        client: HTTPClient
    ) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                if let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}
