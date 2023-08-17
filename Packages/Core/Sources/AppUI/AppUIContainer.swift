//
//  AppUIContainer.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import Foundation

public protocol AppUIContainer {
    associatedtype DisplayableErrorRepository: DisplayableErrorRepositoryProtocol
    var displayableErrorRepository: DisplayableErrorRepository { get }

    associatedtype DogRepository: DogRepositoryProtocol
    var dogRepository: DogRepository { get }

    associatedtype LocalDogBreedRepository: LocalDogBreedRepositoryProtocol
    var localDogBreedRepository: LocalDogBreedRepository { get }

    associatedtype TagRepository: TagRepositoryProtocol
    var tagRepository: TagRepository { get }

    associatedtype UserSettingsRepository: UserSettingsRepositoryProtocol
    var userSettingsRepository: UserSettingsRepository { get }
}

public final class PreviewContainer: AppUIContainer {
    public struct Configuration {
        var didShowWelcome: Bool
    }

    public let displayableErrorRepository: CoreDisplayableErrorRepository

    public let dogRepository: MockDogRepository

    public let localDogBreedRepository: MockLocalDogBreedRepository

    public let tagRepository: MockTagRepository

    public let userSettingsRepository: MockUserSettingsRepository

    public init(configuration: Configuration = .default) {
        self.displayableErrorRepository = .mock()
        self.dogRepository = .mock()
        self.localDogBreedRepository = .init(data: [])
        self.tagRepository = .mock(tags: .mock)
        self.userSettingsRepository = .init(initialValue: .init(didShowWelcome: configuration.didShowWelcome))
    }
}

extension AppUIContainer where Self == PreviewContainer {
    static func preview(_ configuration: PreviewContainer.Configuration = .default) -> Self {
        .init(configuration: configuration)
    }
}

extension PreviewContainer.Configuration {
    public static var `default`: Self {
        .init(
            didShowWelcome: false
        )
    }

    func with<V>(_ property: WritableKeyPath<Self, V>, _ value: V) -> Self {
        var configuration = self
        configuration[keyPath: property] = value
        return configuration
    }
}

extension AppUIContainer {
    public func makeDogBreedImageService() -> DogBreedImageService {
        .init(dependency: .init(
            getDogBreedImage: dogRepository.getDogBreedImage(breed:),
            getDogSubBreedImage: dogRepository.getDogSubBreedImage(breed:subBreed:),
            sendError: displayableErrorRepository.sendError(_:)
        ))
    }

    public func makeRandomDogImageService() -> RandomDogImageService {
        .init(dependency: .init(
            getRandomDogImage: dogRepository.getRandomDogImage,
            sendError: displayableErrorRepository.sendError(_:)
        ))
    }
}
