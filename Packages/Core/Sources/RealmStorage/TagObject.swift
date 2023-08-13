//
//  TagObject.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import RealmSwift
import SwiftUI

final class TagObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var name: String
}

extension Tag {
    init(object: TagObject) {
        self.init(name: object.name)
    }
}

extension TagObject {
    convenience init(data: Tag) {
        self.init()
        self.name = data.name
    }
}

struct RealmTagsContainer: TagsContainerProtocol {
    @ObservedResults(TagObject.self) public var data

    var id: KeyPath<TagObject, String> = \.name

    func body(content: Content) -> some View {
        content
    }

    func container(element: TagObject) -> TagObjectContainer {
        .init(object: element)
    }

    func handle(action: TagsContainerAction) {
        fatalError()
    }
}

struct TagObjectContainer: DataValueContainer {
    @ObservedRealmObject var object: TagObject

    var element: Tag {
        Tag(object: object)
    }

    func body(content: Content) -> some View {
        content
    }
    
    func handle(action: TagsValueAction) {
        fatalError()
    }
}

public struct RealmResolver: TagRepositoryProtocol {
    public init() { }
    
    public func makeTagsContainer() -> some TagsContainerProtocol {
        RealmTagsContainer()
    }

    public func addTag(_ tag: Tag) {
        let realm = try! Realm()
        try! realm.write {
            let object = TagObject(data: tag)
            realm.add(object)
        }
    }
}
