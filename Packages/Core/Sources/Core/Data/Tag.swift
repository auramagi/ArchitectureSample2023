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
        self.state = state
    }
}

extension [Tag] {
    static public var mock: Self {
        [
            .init(name: "sensitive_tag_1"),
            .init(name: "2"),
            .init(name: "3"),
        ]
    }
}
