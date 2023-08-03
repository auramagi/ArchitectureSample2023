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

    public init(name: String) {
        self.name = name
    }
}
