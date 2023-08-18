//
//  TagObject.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import RealmSwift
import SwiftUI

public final class TagObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
}

let globalState = UUID()

extension Tag {
    init(object: TagObject) {
        self.init(name: object.name, state: globalState)
    }
}

public final class RealmTagRepository: TagRepository {
    let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }

    public func makeCollection() -> RealmTagCollection {
        .init()
    }

    public var dataCollectionEnvironment: RealmConfigurationViewModifier {
        .init(configuration: configuration)
    }

    public func makeData(object: TagObject) -> RealmTag {
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

public struct RealmTagCollection: ViewDataCollection {
    @ObservedResults(TagObject.self) public var data

    public let id: KeyPath<TagObject, TagObject.ID> = \.id

    public func handle(_ action: TagCollectionAction) -> Task<Void, Never>? {
        switch action {
        case let .add(tag):
            let object = TagObject()
            object.name = tag.name
            $data.append(object)
            return nil

        case let .delete(offsets):
            $data.remove(atOffsets: offsets)
            return nil

        case .move:
            fatalError()
        }
    }

    public func body(content: Content) -> some View {
        content
            .animation(.default, value: data)
    }
}

public struct RealmTag: ViewData {
    // A wrapper to store a fallback entity in case object is invalidated
    private final class Wrapper: ObservableObject {
        var entity: Tag

        init(entity: Tag) {
            self.entity = entity
        }
    }

    @ObservedRealmObject var object: TagObject

    @StateObject private var wrapper: Wrapper

    init(object: TagObject) {
        self.object = object
        self._wrapper = .init(wrappedValue: .init(entity: .init(object: object))) // assume object is not invalidated on first appearance
    }

    public var entity: Tag {
        if object.isInvalidated {
            return wrapper.entity // return last mapped entity before invalidation
        } else {
            let entity = Tag(object: object)
            wrapper.entity = entity
            return entity
        }
    }

    public func handle(_ action: TagAction) -> Task<Void, Never>? {
        switch action {
        case .delete:
            $object.delete()
            return nil
        }
    }
}
