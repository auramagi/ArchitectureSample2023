//
//  DogBreedViewData.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public protocol DogBreedViewData: ViewDataCollectionBuilder<BreedListItem, DogBreedViewDataAction, Void> { }

public enum DogBreedViewDataAction {
    case refresh
}

public struct CoreDogBreedViewData: DogBreedViewData {
    let getBreedList: () async throws -> BreedList

    public init(getBreedList: @escaping () async throws -> BreedList) {
        self.getBreedList = getBreedList
    }

    public func makeObjectCollectionContainer() -> CoreDogBreedList {
        .init(getBreedList: getBreedList)
    }

    public func makeObjectContainer(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}

public struct MockDogBreedViewData: DogBreedViewData {
    let data: [BreedListItem]

    public func makeObjectCollectionContainer() -> MockDogBreedList {
        .init(data: data)
    }

    public func makeObjectContainer(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}

public struct CoreDogBreedList: DataCollectionContainer {
    let getBreedList: () async throws -> BreedList

    @State private var breeds: LoadingState<[BreedListItem]> = .notStarted

    @State private var taskID = UUID()

    @State private var loadedID = UUID()

    public var data: [BreedListItem] {
        (try? breeds.result?.get()) ?? []
    }

    public let id: KeyPath<BreedListItem, BreedListItem> = \.self

    public func handle(_ action: DogBreedViewDataAction) -> Task<Void, Never>? {
        taskID = .init()
        return Task {
            try? await Task.sleep(for: .seconds(1)) // TODO: Connect with actual task
        }
    }

    public func body(content: Content) -> some View {
        content
            .task(id: taskID) {
                guard loadedID != taskID else { return } // Load only once unless reloading by button
                loadedID = taskID
                breeds = .loading
                do {
                    let breedList = try await getBreedList()
                    breeds = .loaded(.success(breedList.map()))
                } catch {
                    breeds = .loaded(.failure(error))
                }
            }
    }
}

public struct MockDogBreedList: DataCollectionContainer {
    @State public var data: [BreedListItem]

    public let id: KeyPath<BreedListItem, BreedListItem> = \.self

    public func handle(_ action: DogBreedViewDataAction) -> Task<Void, Never>? {
        data = BreedList.mock.map()
        return nil
    }
}

public struct MockDogBreedObject: DataValueContainer {
    public let element: BreedListItem

    public func handle(_ action: Void) -> Task<Void, Never>? {
        nil
    }
}
