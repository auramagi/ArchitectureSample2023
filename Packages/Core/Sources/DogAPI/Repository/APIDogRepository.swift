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
    public func getRandomDog() async throws -> URL {
        try await execute(API.RandomImageRequest.Single.Get()).message
    }

    public func getBreedList() async throws -> BreedList {
        try await execute(API.BreedListRequest.Get()).message
    }
}
