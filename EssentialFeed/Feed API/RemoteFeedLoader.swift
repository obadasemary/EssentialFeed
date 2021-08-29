//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 27.06.2021.
//

import Foundation

public final class RemoteFeedLoader {

    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {

        case connectivity
        case invalidData
    }

    public enum Result: Equatable {

        case success([FeedItem])
        case failure(Error)
    }

    public init(url: URL = URL(string: "https://a-url.com")!, client: HTTPClient) {

        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in

            switch result {
            case let .success(data, response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
}


