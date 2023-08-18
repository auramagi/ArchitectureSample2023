//
//  TagRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Combine
import SwiftUI

public protocol TagViewDataCollectionRepository: ViewDataCollectionRepository<Tag, TagsContainerAction, TagsValueAction> { }

public enum TagsContainerAction {
    case add(tag: Tag)

    case delete(offsets: IndexSet)

    case move(fromOffsets: IndexSet, toOffset: Int)
}

public enum TagsValueAction {
    case delete
}

// MARK: Mock implementation

public struct MockTagRepository: TagViewDataCollectionRepository {
    public typealias Entity = Tag

    public typealias Object = MockTagObject

    public typealias ObjectProperty = MockTagContainer

    public typealias ViewDataCollectionType = MockTagList

    public var environmentModifier: EmptyModifier { .identity }

    let storage: MockTagStorage

    init(tags: [Tag]) {
        self.storage = .init(tags: tags.map { .init(tag: $0) })
    }

    public func makeCollection() -> MockTagList {
        .init(storage: storage)
    }

    public func makeData(object: MockTagObject) -> MockTagContainer {
        .init(object: object) { object, action in
            switch action {
            case .delete:
                storage.tags.removeAll { $0 === object }
            }
        }
    }
}

extension TagViewDataCollectionRepository where Self == MockTagRepository {
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

public struct MockTagList: ViewDataCollection {
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

    public func handle(_ action: TagsContainerAction) -> Task<Void, Never>? {
        switch action {
        case let .add(tag):
            storage.tags.append(.init(tag: tag))

        case let .delete(offsets):
            storage.tags.remove(atOffsets: offsets)

        case let .move(fromOffsets, toOffset):
            storage.tags.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
        return nil
    }
}

public struct MockTagContainer: ViewData {
    @ObservedObject var object: MockTagObject
    
    let actionHandler: (MockTagObject, TagsValueAction) -> Void

    public var element: Tag {
        object.tag
    }
    
    public func handle(_ action: TagsValueAction) -> Task<Void, Never>? {
        actionHandler(object, action)
        return nil
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

struct TagsContainerView<ViewDataCollectionRepository: TagViewDataCollectionRepository>: View {
    var tags: ViewDataCollectionRepository

    var body: some View {
        WithViewDataCollection(tags) { tags in
            ForEach(tags) { value in
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
                tags.handle(.delete(offsets: offsets))
            }
            .onMove { fromOffsets, toOffset in
                tags.handle(.move(fromOffsets: fromOffsets, toOffset: toOffset))
            }
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static let tags: some TagViewDataCollectionRepository = .mock(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    
    static var previews: some View {
        NavigationStack {
            List {
                TagsContainerView(tags: tags)
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif
            }
        }
    }
}
