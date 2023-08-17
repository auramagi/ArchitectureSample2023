//
//  DogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public protocol LocalDogBreedRepositoryProtocol {
    associatedtype ViewData: DogBreedViewData

    func viewData() -> ViewData
}

public final class CoreLocalDogBreedRepository: LocalDogBreedRepositoryProtocol {
    let getBreedList: () async throws -> BreedList

    public init(getBreedList: @escaping () async throws -> BreedList) {
        self.getBreedList = getBreedList
    }
    
    public func viewData() -> some DogBreedViewData {
        .make {
            CoreDogBreedList(getBreedList: self.getBreedList)
        } vd: { object in
            MockDogBreedObject(element: object)
        } environmentModifier: {
            EmptyModifier.identity
        }
    }
}

public final class MockLocalDogBreedRepository: LocalDogBreedRepositoryProtocol {
    let data: [BreedListItem]

    public init(data: [BreedListItem]) {
        self.data = data
    }

    public func viewData() -> some DogBreedViewData {
        .make {
            MockDogBreedList(data: self.data)
        } vd: { object in
            MockDogBreedObject(element: object)
        } environmentModifier: {
            EmptyModifier.identity
        }
    }
}
