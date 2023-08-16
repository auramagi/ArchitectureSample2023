//
//  DogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public protocol DogRepositoryProtocol {
    func getRandomDog() async throws -> URL

    func getBreedList() async throws -> BreedList
}

extension DogRepositoryProtocol where Self: MockDogRepository {
    public static func mock(
        getRandomDog: @escaping () async -> URL = { .mock(path: "random_dog") },
        getBreedList: @escaping () async -> BreedList = { .mock }
    ) -> Self {
        .init(
            getRandomDog: getRandomDog,
            getBreedList: getBreedList
        )
    }
}

public final class MockDogRepository: DogRepositoryProtocol {
    let _getRandomDog: () async throws -> URL

    let _getBreedList: () async throws -> BreedList

    init(
        getRandomDog: @escaping () async throws -> URL,
        getBreedList: @escaping () async throws -> BreedList
    ) {
        self._getRandomDog = getRandomDog
        self._getBreedList = getBreedList
    }

    public func getRandomDog() async throws -> URL {
        try await _getRandomDog()
    }

    public func getBreedList() async throws -> BreedList {
        try await _getBreedList()
    }
}

extension URL {
    static var baseMock = URL(string: "mock://mock")!

    public static func mock(path: String) -> Self {
        baseMock.appending(path: path)
    }
}
