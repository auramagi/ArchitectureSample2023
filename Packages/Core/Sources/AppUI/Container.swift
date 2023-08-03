//
//  File.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import Foundation

public protocol AppContainer {
    associatedtype TagRepository: TagRepositoryProtocol

    var tagRepository: TagRepository { get }
}

public final class PreviewContainer: AppContainer {
    public init() { }
    public var tagRepository: MockTagRepository {
        .init(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    }
}
