//
//  MockLocalDogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public final class MockLocalDogBreedRepository: LocalDogBreedRepository {
    let data: [BreedListItem]

    public init(data: [BreedListItem]) {
        self.data = data
    }

    public func makeCollection() -> MockDogBreedList {
        .init(data: self.data)
    }

    public func makeData(object: BreedListItem) -> MockDogBreedObject {
        .init(entity: object)
    }
}

public extension LocalDogBreedRepository where Self == MockLocalDogBreedRepository {
    static func mock(data: [BreedListItem] = .mock()) -> Self {
        .init(data: data)
    }
}

public struct MockDogBreedList: ViewDataCollection {
    @State public var data: [BreedListItem]

    public let id: KeyPath<BreedListItem, BreedListItem> = \.self

    public func handle(_ action: DogBreedViewDataAction) -> Task<Void, Never>? {
        data = BreedList.mock.map()
        return nil
    }
}

public struct MockDogBreedObject: ViewData {
    public let entity: BreedListItem

    public func handle(_ action: Void) -> Task<Void, Never>? {
        nil
    }
}
