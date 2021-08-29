//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 23.06.2021.
//

import Foundation

public enum LoadFeedResult {

    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @ escaping (LoadFeedResult) -> Void)
}
