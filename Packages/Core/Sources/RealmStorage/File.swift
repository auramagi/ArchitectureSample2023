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

struct TagListView<Content: View>: View {
    var content: (Tag) -> Content

    @ObservedResults(TagObject.self) private var tags

    var body: some View {
        ForEach(tags) { tag in
            content(.init(object: tag))
        }
    }
}

enum RealmResolver: TagRepositoryProtocol {
    func makeTagList<C: View>(content: @escaping (Tag) -> C) -> AnyView {
        TagListView(content: content).asAnyView()
    }
}
