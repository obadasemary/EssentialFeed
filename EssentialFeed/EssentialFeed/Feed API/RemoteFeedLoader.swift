//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 26.12.2024.
//

import Foundation

public enum HTTPCLientResult {
    case success(HTTPURLResponse)
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
    
    public init(
        url: URL,
        client: HTTPClient
    ) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let response):
                completion(.invalidData)
            case .failure(let error):
                completion(.connectivity)
            }
        }
    }
}


