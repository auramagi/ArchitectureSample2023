//
//  DogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public protocol LocalDogBreedRepositoryProtocol: ViewDataCollectionRepository<BreedListItem, DogBreedViewDataAction, Void> {

}

public final class CoreLocalDogBreedRepository: LocalDogBreedRepositoryProtocol {
    let getBreedList: () async throws -> BreedList

    public init(getBreedList: @escaping () async throws -> BreedList) {
        self.getBreedList = getBreedList
    }

    public func makeCollection() -> CoreDogBreedList {
        .init(getBreedList: getBreedList)
    }

    public func makeData(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}

public final class MockLocalDogBreedRepository: LocalDogBreedRepositoryProtocol {
    let data: [BreedListItem]

    public init(data: [BreedListItem]) {
        self.data = data
    }

    public func makeCollection() -> MockDogBreedList {
        .init(data: self.data)
    }

    public func makeData(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}
