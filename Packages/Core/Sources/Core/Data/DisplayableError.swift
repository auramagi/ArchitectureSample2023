//
//  DisplayableError.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct DisplayableError: Identifiable, LocalizedError {
    public enum ID: Hashable {
        case string(String)

        case uuid(UUID)
    }

    public let id: ID = .uuid(.init())

    public let underlying: Error?

    public let message: String

    public var errorDescription: String? {
        message
    }
}
