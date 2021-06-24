//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 23.06.2021.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @ escaping (LoadFeedResult) -> Void)
}
