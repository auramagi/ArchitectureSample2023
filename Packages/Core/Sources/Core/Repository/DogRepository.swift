//
//  DogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

//enum DogRepository {
//    typealias GetRandomDog = () async throws -> URL
//}
public protocol DogRepositoryProtocol {
    func getRandomDog() async throws -> URL
}

public protocol DisplayableErrorRepositoryProtocol {
    var currentErrors: AsyncStream<[DisplayableError]> { get }

    func sendError(_ error: DisplayableError) async
}

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

import Combine

public final class CoreDisplayableErrorRepository: DisplayableErrorRepositoryProtocol {
    let _errors: CurrentValueSubject<[DisplayableError], Never>

    public init(errors: [DisplayableError]) {
        self._errors = .init(errors)
    }

    public var currentErrors: AsyncStream<[DisplayableError]> {
        var iterator = _errors.values.makeAsyncIterator()
        return .init { await iterator.next() }
    }

    public func sendError(_ error: DisplayableError) async {
        _errors.value.append(error)
        _ = await currentErrors.first { !$0.contains(id: error.id) }
    }
}

extension DisplayableErrorRepositoryProtocol where Self: CoreDisplayableErrorRepository {
    public static func mock(errors: [DisplayableError] = []) -> Self {
        .init(errors: errors)
    }
}

extension Collection where Element: Identifiable {
    public func contains(id: Element.ID) -> Bool {
        contains { $0.id == id }
    }
}

public struct DisplayableError: Identifiable, LocalizedError {
    public enum ID: Hashable {
        case string(String)

        case uuid(UUID)
    }

    public let id: ID = .uuid(.init())

    public let underlying: Error

    public let message: String
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
