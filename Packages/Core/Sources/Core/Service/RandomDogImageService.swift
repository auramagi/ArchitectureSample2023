//
//  RandomDogImageService.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct RandomDogImageService {
    public struct Dependency {
        let getRandomDogImage: () async throws -> URL

        let sendError: (_ error: DisplayableError) async -> Void

        public init(
            getRandomDogImage: @escaping () async throws -> URL,
            sendError: @escaping (_ error: DisplayableError) async -> Void
        ) {
            self.getRandomDogImage = getRandomDogImage
            self.sendError = sendError
        }
    }

    let dependency: Dependency

    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    public func getRandomDogImage() async -> URL? {
        do {
            return try await dependency.getRandomDogImage()
        } catch {
            let error = DisplayableError(underlying: error, message: error.localizedDescription)
            await dependency.sendError(error)
            return nil
        }
    }
}
