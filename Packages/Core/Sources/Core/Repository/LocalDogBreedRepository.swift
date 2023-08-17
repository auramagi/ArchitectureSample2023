//
//  DogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

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
        CoreDogBreedViewData(getBreedList: getBreedList)
    }
}

public final class MockLocalDogBreedRepository: LocalDogBreedRepositoryProtocol {
    let _viewData: MockDogBreedViewData

    public init(data: [BreedListItem]) {
        self._viewData = .init(data: data)
    }

    public func viewData() -> some DogBreedViewData {
        _viewData
    }
}
