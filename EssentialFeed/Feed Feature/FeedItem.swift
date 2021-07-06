//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 23.06.2021.
//

import Foundation

public struct FeedItem: Equatable {

    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
