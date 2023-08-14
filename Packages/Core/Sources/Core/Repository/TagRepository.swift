//
//  TagRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Combine
import SwiftUI

public protocol TagRepositoryProtocol: ViewDataCollectionBuilder<Tag, TagsContainerAction, TagsValueAction> { }

public enum TagsContainerAction {
    case add(tag: Tag)

    case delete(offsets: IndexSet)

    case move(fromOffsets: IndexSet, toOffset: Int)
}

public enum TagsValueAction {
    case delete
}

// MARK: Mock implementation

public struct MockTagRepository: TagRepositoryProtocol {
    public typealias Entity = Tag

    public typealias Object = MockTagObject

    public typealias ObjectProperty = MockTagView

    public typealias ObjectCollectionContainer = MockTagList

    let storage: MockTagStorage

    init(tags: [Tag]) {
        self.storage = .init(tags: tags.map { .init(tag: $0) })
    }

    public func makeObjectCollectionContainer() -> MockTagList {
        .init(storage: storage)
    }

    public func makeObjectContainer(object: MockTagObject) -> MockTagView {
        .init(tag: object) { object, action in
            switch action {
            case .delete:
                storage.tags.removeAll { $0 === object }
            }
        }
    }
}

extension TagRepositoryProtocol where Self == MockTagRepository {
    public static func mock(tags: [Tag]) -> Self {
        .init(tags: tags)
    }
}

final class MockTagStorage: ObservableObject {
    @Published var tags: [MockTagObject]

    init(tags: [MockTagObject]) {
        self.tags = tags
    }
}

public struct MockTagList: DataCollectionContainer {
    @ObservedObject var storage: MockTagStorage

    public var data: [MockTagObject] { storage.tags }

    public let id = \MockTagObject.tag.id

    public func body(content: Content) -> some View {
        content
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                storage.tags.shuffle()
                print("shuffle", storage.tags.map(\.tag.id))
            }
    }

    public func handle(action: TagsContainerAction) {
        switch action {
        case let .add(tag):
            storage.tags.append(.init(tag: tag))

        case let .delete(offsets):
            storage.tags.remove(atOffsets: offsets)

        case let .move(fromOffsets, toOffset):
            storage.tags.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
    }
}

public struct MockTagView: DataValueContainer {
    @ObservedObject var tag: MockTagObject
    
    let actionHandler: (MockTagObject, TagsValueAction) -> Void

    public var element: Tag {
        tag.tag
    }
    
    public func handle(_ action: TagsValueAction) {
        actionHandler(tag, action)
    }
}

public final class MockTagObject: ObservableObject {
    @Published var tag: Tag

    init(tag: Tag) {
        self.tag = tag

        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .map { _ in
                var tag = tag
                tag.state = .init()
                return tag
            }
            .assign(to: &$tag)
    }
}

struct TagsContainerView<Repo: TagRepositoryProtocol>: View {
    var tags: Repo

    var body: some View {
        tags.build { collection in
            collection.forEach { value in
                VStack(alignment: .leading) {
                    Text("VendedElement: \(value.element.id)")

                    Text(value.element.state.uuidString)
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Button("Delete", role: .destructive) {
                        withAnimation {
                            value.handle(.delete)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .onDelete { offsets in
                collection.handle(.delete(offsets: offsets))
            }
            .onMove { fromOffsets, toOffset in
                collection.handle(.move(fromOffsets: fromOffsets, toOffset: toOffset))
            }
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static let repo: some TagRepositoryProtocol = .mock(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    
    static var previews: some View {
        NavigationStack {
            List {
                TagsContainerView(tags: repo)
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif
            }
        }
    }
}
