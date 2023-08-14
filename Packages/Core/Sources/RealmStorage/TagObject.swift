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

extension Tag {
    init(object: TagObject) {
        if object.isInvalidated {
            self.init(name: "Invalidated object")
        } else {
            self.init(name: object.name)
        }
    }
}

extension TagObject {
    convenience init(data: Tag) {
        self.init()
        self.name = data.name
    }
}

public struct RealmTagsContainer: DataCollectionContainer {
    @ObservedResults(TagObject.self) public var data

    public var id: KeyPath<TagObject, String> = \.name

    public func body(content: Content) -> some View {
        content
    }

    public func handle(action: TagsContainerAction) {
        switch action {
        case let .add(tag):
            $data.append(.init(data: tag))

        case let .delete(offsets):
            $data.remove(atOffsets: offsets)
            
        case .move:
            fatalError()
        }
    }
}

public struct TagObjectContainer: DataValueContainer {
    @ObservedRealmObject var object: TagObject

    public var element: Tag {
        Tag(object: object)
    }

    public func body(content: Content) -> some View {
        content
    }
    
    public func handle(_ action: TagsValueAction) {
        switch action {
        case .delete:
            $object.delete()
        }
    }
}

public struct RealmResolver: TagRepositoryProtocol {
    public init() { }

    public func body(content: Content) -> some View {
        content
            .environment(\.realmConfiguration, .defaultConfiguration)
    }

    public func makeObjectCollectionContainer() -> RealmTagsContainer {
        .init()
    }

    public func makeObjectContainer(object: TagObject) -> TagObjectContainer {
        .init(object: object)
    }
}
