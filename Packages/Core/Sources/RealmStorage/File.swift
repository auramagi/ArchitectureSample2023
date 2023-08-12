//
//  File.swift
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

struct TagListProvider: TagListProviderProtocol {
    @ObservedResults(TagObject.self) public var data

    var id: KeyPath<TagObject, String> = \.name

    func body(content: Content) -> some View {
        content
    }

    func map(_ element: TagObject) -> TagObjectProvider {
        .init(object: element)
    }

    func handle(action: TagListAction) {
        fatalError()
    }
}

struct TagObjectProvider: ViewDataElementProvider {
    @ObservedRealmObject var object: TagObject

    var element: Tag {
        Tag(object: object)
    }

    func body(content: Content) -> some View {
        content
    }
}

public struct RealmResolver: TagRepositoryProtocol {
    public init() { }
    
    public func makeTagList() -> some TagListProviderProtocol {
        TagListProvider()
    }

    public func addTag(_ tag: Tag) {
        let realm = try! Realm()
        try! realm.write {
            let object = TagObject(data: tag)
            realm.add(object)
        }
    }
}
