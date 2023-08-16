//
//  DogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public protocol DogRepositoryProtocol {
    func getRandomDog() async throws -> URL
}

extension DogRepositoryProtocol where Self: MockDogRepository {
    public static func mock(getRandomDog: @escaping () async -> URL = { .mock(path: "random_dog") }) -> Self {
        .init(getRandomDog: getRandomDog)
    }
}

public final class MockDogRepository: DogRepositoryProtocol {
    let _getRandomDog: () async throws -> URL

    init(getRandomDog: @escaping () async throws -> URL) {
        self._getRandomDog = getRandomDog
    }

    public func getRandomDog() async throws -> URL {
        try await _getRandomDog()
    }
}

extension URL {
    static var baseMock = URL(string: "mock://mock")!

    public static func mock(path: String) -> Self {
        baseMock.appending(path: path)
    }
}
