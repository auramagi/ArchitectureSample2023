//
//  Tag.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Foundation
//
//public struct Tag: Hashable, Identifiable {
//    public var id: String {
//        name
//    }
//
//    public let name: String
//
//    public init(name: String) {
//        self.name = name
//    }
//}

import Combine

public final class Tag: ObservableObject, Identifiable {
    public var id: String {
        name
    }

    public let name: String

    @Published public var uuid = UUID()

    public init(name: String) {
        self.name = name

        Timer.publish(every: 1, on: .main, in: .common).autoconnect().map { _ in UUID() }.assign(to: &$uuid)
    }
}
