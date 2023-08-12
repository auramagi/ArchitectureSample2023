//
//  Tag.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Foundation

public struct Tag: Hashable, Identifiable {
    public var id: String {
        name
    }

    public let name: String

    public var state: UUID

    public init(name: String, state: UUID = .init()) {
        self.name = name
        self.state = .init()
    }
}
