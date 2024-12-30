//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Abdelrahman Mohamed on 31.12.2024.
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
