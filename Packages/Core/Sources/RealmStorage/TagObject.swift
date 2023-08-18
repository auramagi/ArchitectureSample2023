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

public final class RealmTagRepository: TagRepository {
    let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }

    public func makeCollection() -> RealmTagCollection {
        .init()
    }

    public func makeData(object: TagObject) -> RealmTag {
        .init(object: object)
    }
}

public struct RealmTagCollection: ViewDataCollection {
    @ObservedResults(TagObject.self) public var data

    public let id: KeyPath<TagObject, String> = \.name

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
}

public struct AAA: View {
    @ObservedResults(TagObject.self) public var data

    public init() { }
    
    public var body: some View {
        SwiftUI.List {
            ForEach(data) { e in
                VStack {
                    Color.red.modifier(
                        RealmTag(object: e)
                    )
                }
            }

            Button("Add") {
                withAnimation {
                    let object = TagObject()
                    object.name = UUID().uuidString
                    $data.append(object)
                }
            }
        }
        .animation(.default, value: data)
    }
}

public struct RealmTag: ViewData {
    @ObservedRealmObject var object: TagObject

    public var entity: Tag {
        .init(object: object)
    }

    public func handle(_ action: TagAction) -> Task<Void, Never>? {
        switch action {
        case .delete:
            $object.delete()
            return nil
        }
    }
}
