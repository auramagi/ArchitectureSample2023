//
//  GenericError.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct GenericError: LocalizedError {
    public let message: String

    public init(message: String) {
        self.message = message
    }

    public var errorDescription: String? {
        message
    }
}

public extension Error where Self == GenericError {
    static func message(_ message: String) -> Self {
        .init(message: message)
    }
}
