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

//struct TagListView<Content: View>: View {
//    var content: (Tag) -> Content
//
//    @ObservedResults(TagObject.self) private var tags
//
//    var body: some View {
//        ForEach(tags) { tag in
//            content(.init(object: tag))
//        }
//    }
//}

struct TagListProvider: ViewDataProvider {
    typealias ID = String

    typealias VendedElement = Tag

    typealias VendedElementProvider = TagObjectView

    typealias Data = Results<TagObject>

    @ObservedResults(TagObject.self) public var data

    var id: KeyPath<TagObject, String> = \TagObject.name


    func body(content: Content) -> some View {
        content
    }

    func map(_ element: TagObject) -> TagObjectView {
        .init(object: element)
    }
}

struct TagObjectView: ViewDataElementProvider {
    let object: TagObject

    var element: Tag {
        Tag(object: object)
    }

    func body(content: Content) -> some View {
        content
    }
}

public struct RealmResolver: TagRepositoryProtocol {
    public init() { }
    
    public func makeTagList() -> some ViewDataProvider<Tag> {
        TagListProvider()
    }
}
