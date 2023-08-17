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

    public func makeCollection() -> CoreDogBreedList {
        .init(getBreedList: getBreedList)
    }

    public func makeData(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}

public struct MockDogBreedViewData: DogBreedViewData {
    let data: [BreedListItem]

    public func makeCollection() -> MockDogBreedList {
        .init(data: data)
    }

    public func makeData(object: BreedListItem) -> MockDogBreedObject {
        .init(element: object)
    }
}

public struct CoreDogBreedList: ViewDataCollection {
    let getBreedList: () async throws -> BreedList

    @State private var breeds: [BreedListItem] = []

    @State private var taskID = UUID()

    @State private var loadedID: UUID?

    public var data: [BreedListItem] {
        breeds
    }

    public let id: KeyPath<BreedListItem, BreedListItem> = \.self

    public func handle(_ action: DogBreedViewDataAction) -> Task<Void, Never>? {
        return Task {
            // TODO: Connect with actual task
            try? await Task.sleep(for: .milliseconds(500))
            taskID = .init()
            try? await Task.sleep(for: .milliseconds(500))
        }
    }

    public func body(content: Content) -> some View {
        content
            .task(id: taskID) {
                guard loadedID != taskID else { return } // Load only once unless reloading by button
                loadedID = taskID
                do {
                    let breedList = try await getBreedList()
                    breeds = breedList.map()
                } catch {
                    loadedID = nil
                }
            }
    }
}

public struct MockDogBreedList: ViewDataCollection {
    @State public var data: [BreedListItem]

    public let id: KeyPath<BreedListItem, BreedListItem> = \.self

    public func handle(_ action: DogBreedViewDataAction) -> Task<Void, Never>? {
        data = BreedList.mock.map()
        return nil
    }
}

public struct MockDogBreedObject: ViewData {
    public let element: BreedListItem

    public func handle(_ action: Void) -> Task<Void, Never>? {
        nil
    }
}
