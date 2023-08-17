//
//  DogBreedImageService.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct DogBreedImageService {
    public struct Dependency {
        let getDogBreedImage: (Breed) async throws -> URL

        let getDogSubBreedImage: (Breed, SubBreed) async throws -> URL

        let sendError: (_ error: DisplayableError) async -> Void

        public init(
            getDogBreedImage: @escaping (Breed) async throws -> URL,
            getDogSubBreedImage: @escaping (Breed, SubBreed) async throws -> URL,
            sendError: @escaping (_ error: DisplayableError) async -> Void
        ) {
            self.getDogBreedImage = getDogBreedImage
            self.getDogSubBreedImage = getDogSubBreedImage
            self.sendError = sendError
        }
    }

    let dependency: Dependency

    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    public func getDogBreedImage(breed: ConcreteBreed) async -> URL? {
        do {
            if let subBreed = breed.subBreed {
                return try await dependency.getDogSubBreedImage(breed.breed, subBreed)
            } else {
                return try await dependency.getDogBreedImage(breed.breed)
            }
        } catch {
            let error = DisplayableError(underlying: error, message: error.localizedDescription)
            await dependency.sendError(error)
            return nil
        }
    }
}
