//
//  Container.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import Foundation

public protocol AppUIContainer {
    associatedtype DisplayableErrorRepository: DisplayableErrorRepositoryProtocol
    var displayableErrorRepository: DisplayableErrorRepository { get }

    associatedtype DogRepository: DogRepositoryProtocol
    var dogRepository: DogRepository { get }

    associatedtype TagRepository: TagRepositoryProtocol
    var tagRepository: TagRepository { get }
}

public final class PreviewContainer: AppUIContainer {
    public let displayableErrorRepository: CoreDisplayableErrorRepository

    public let dogRepository: MockDogRepository

    public let tagRepository: MockTagRepository

    public init() {
        self.displayableErrorRepository = .mock()
        self.dogRepository = .mock()
        self.tagRepository = .mock(tags: .mock)
    }
}
