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

struct TagListView: ContentResolverProtocol {
    @ObservedResults(TagObject.self) private var tags

    func body() -> Results<TagObject> {
        tags
    }

    func map(_ content: TagObject) -> Tag {
        .init(object: content)
    }
}

enum RealmResolver: TagRepositoryProtocol {
    func makeResolver() -> TagListView {
        .init()
    }
}
