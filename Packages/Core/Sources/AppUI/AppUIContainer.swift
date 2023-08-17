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

    associatedtype TagRepository: TagRepositoryProtocol
    var tagRepository: TagRepository { get }

    associatedtype UserSettingsRepository: UserSettingsRepositoryProtocol
    var userSettingsRepository: UserSettingsRepository { get }
}

public final class PreviewContainer: AppUIContainer {
    public let displayableErrorRepository: CoreDisplayableErrorRepository

    public let dogRepository: MockDogRepository

    public let tagRepository: MockTagRepository

    public let userSettingsRepository: MockUserSettingsRepository

    public init() {
        self.displayableErrorRepository = .mock()
        self.dogRepository = .mock()
        self.tagRepository = .mock(tags: .mock)
        self.userSettingsRepository = .init(initialValue: .init(didShowWelcome: false))
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
