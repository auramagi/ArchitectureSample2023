//
//  APIDogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

public typealias APIDogRepository = APIClient

extension APIDogRepository: DogRepositoryProtocol {
    public func getRandomDogImage() async throws -> URL {
        try await execute(API.RandomImageRequest.Single.Get()).message
    }

    public func getDogBreedImage(breed: Breed) async throws -> URL {
        try await execute(API.BreedImageRequest.Random.Single.Get(breed: breed)).message
    }

    public func getDogSubBreedImage(breed: Breed, subBreed: SubBreed) async throws -> URL {
        try await execute(API.SubBreedImageRequest.Random.Single.Get(breed: breed, subBreed: subBreed)).message
    }

    public func getBreedList() async throws -> BreedList {
        try await execute(API.BreedListRequest.Get()).message
    }

}
