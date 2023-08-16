//
//  DogService.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public struct DogService {
    public struct Dependency {
        let getRandomDog: () async throws -> URL

        let sendError: (_ error: DisplayableError) async -> Void

        public init(
            getRandomDog: @escaping () async throws -> URL,
            sendError: @escaping (_ error: DisplayableError) async -> Void
        ) {
            self.getRandomDog = getRandomDog
            self.sendError = sendError
        }
    }

    let dependency: Dependency

    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    public func getRandomDog() async -> URL? {
        do {
            return try await dependency.getRandomDog()
        } catch {
            let error = DisplayableError(underlying: error, message: error.localizedDescription)
            await dependency.sendError(error)
            return nil
        }
    }
}
