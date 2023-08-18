//
//  AppUIContainer.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import Foundation

public protocol AppUIContainer {
    associatedtype DisplayableErrorRepositoryType: DisplayableErrorRepository
    var displayableErrorRepository: DisplayableErrorRepositoryType { get }

    associatedtype DogRepositoryType: DogRepository
    var dogRepository: DogRepositoryType { get }

    associatedtype DogBreedRepositoryType: DogBreedRepository
    var dogBreedRepository: DogBreedRepositoryType { get }

    associatedtype TagRepositoryType: TagRepository
    var tagRepository: TagRepositoryType { get }

    associatedtype UserSettingsRepositoryType: UserSettingsRepository
    var userSettingsRepository: UserSettingsRepositoryType { get }
}

public final class PreviewContainer: AppUIContainer {
    public struct Configuration {
        var didShowWelcome: Bool
    }

    public let displayableErrorRepository: CoreDisplayableErrorRepository

    public let dogRepository: MockDogRepository

    public let dogBreedRepository: MockDogBreedRepository

    public var tagRepository: MockTagRepository

    public let userSettingsRepository: MockUserSettingsRepository

    public init(configuration: Configuration = .default) {
        self.displayableErrorRepository = .mock()
        self.dogRepository = .mock()
        self.dogBreedRepository = .mock()
        self.tagRepository = .mock(tags: .mock)
        self.userSettingsRepository = .mock(initialValue: .init(didShowWelcome: configuration.didShowWelcome))
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
