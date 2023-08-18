//
//  DogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public protocol DogRepository {
    func getRandomDogImage() async throws -> URL

    func getDogBreedImage(breed: Breed) async throws -> URL

    func getDogSubBreedImage(breed: Breed, subBreed: SubBreed) async throws -> URL

    func getBreedList() async throws -> BreedList
}

extension DogRepository where Self: MockDogRepository {
    public static func mock(
        getRandomDogImage: @escaping () async -> URL = { .mock(path: "random_dog") },
        getDogBreedImage: @escaping (Breed) async throws -> URL = { _ in .mock(path: "random_dog") },
        getDogSubBreedImage: @escaping (Breed, SubBreed) async throws -> URL = { _, _ in .mock(path: "random_dog") },
        getBreedList: @escaping () async -> BreedList = { .mock }
    ) -> Self {
        .init(
            getRandomDogImage: getRandomDogImage,
            getDogBreedImage: getDogBreedImage,
            getDogSubBreedImage: getDogSubBreedImage,
            getBreedList: getBreedList
        )
    }
}

public final class MockDogRepository: DogRepository {
    let _getRandomDogImage: () async throws -> URL

    let _getDogBreedImage: (Breed) async throws -> URL

    let _getDogSubBreedImage: (Breed, SubBreed) async throws -> URL

    let _getBreedList: () async throws -> BreedList

    init(
        getRandomDogImage: @escaping () async throws -> URL,
        getDogBreedImage: @escaping (Breed) async throws -> URL,
        getDogSubBreedImage: @escaping (Breed, SubBreed) async throws -> URL,
        getBreedList: @escaping () async throws -> BreedList
    ) {
        self._getRandomDogImage = getRandomDogImage
        self._getDogBreedImage = getDogBreedImage
        self._getDogSubBreedImage = getDogSubBreedImage
        self._getBreedList = getBreedList
    }

    public func getRandomDogImage() async throws -> URL {
        try await _getRandomDogImage()
    }

    public func getBreedList() async throws -> BreedList {
        try await _getBreedList()
    }

    public func getDogBreedImage(breed: Breed) async throws -> URL {
        try await _getDogBreedImage(breed)
    }

    public func getDogSubBreedImage(breed: Breed, subBreed: SubBreed) async throws -> URL {
        try await _getDogSubBreedImage(breed, subBreed)
    }
}

extension URL {
    static var baseMock = URL(string: "mock://mock")!

    public static func mock(path: String) -> Self {
        baseMock.appending(path: path)
    }
}
