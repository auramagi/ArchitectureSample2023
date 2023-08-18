//
//  RealmBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import Core
import RealmSwift
import SwiftUI

public final class RealmBreedRepository: DogBreedRepository {
    let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }

    public func makeCollection() -> RealmBreedViewDataCollection {
        .init()
    }

    public var dataCollectionEnvironment: RealmConfigurationViewModifier {
        .init(configuration: configuration)
    }

    public func makeData(object: BreedListItemObject) -> RealmBreedViewData {
        .init(object: object)
    }

    public var dataEnvironment: RealmConfigurationViewModifier {
        .init(configuration: configuration)
    }
}

public struct RealmConfigurationViewModifier: ViewModifier {
    let configuration: Realm.Configuration

    public func body(content: Content) -> some View {
        content
            .environment(\.realmConfiguration, configuration)
    }
}

public struct RealmBreedViewDataCollection: ViewDataCollection {
    @ObservedResults(BreedListObject.self) public var list

    public var data: RealmSwift.List<BreedListItemObject> {
        list.first?.breeds ?? .init()
    }

    public let id: KeyPath<BreedListItemObject, BreedListItemObject.ID> = \.id

    public func body(content: Content) -> some View {
        content
            .animation(.default, value: data)
    }

    public func handle(_ action: DogBreedCollectionAction) -> Task<Void, Never>? {
        switch action {
        case .refresh:
            return nil
        }
    }
}

public struct RealmBreedViewData: ViewData {
    // A wrapper to store a fallback entity in case object is invalidated
    private final class Wrapper: ObservableObject {
        var entity: BreedListItem

        init(entity: BreedListItem) {
            self.entity = entity
        }
    }

    @ObservedRealmObject var object: BreedListItemObject

    @StateObject private var wrapper: Wrapper

    init(object: BreedListItemObject) {
        self.object = object
        self._wrapper = .init(wrappedValue: .init(entity: .init(object: object))) // assume object is not invalidated on first appearance
    }

    public var entity: BreedListItem {
        if object.isInvalidated {
            return wrapper.entity // return last mapped entity before invalidation
        } else {
            let entity = BreedListItem(object: object)
            wrapper.entity = entity
            return entity
        }
    }
}
