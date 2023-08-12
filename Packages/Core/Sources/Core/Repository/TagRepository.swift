//
//  TagRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Combine
import SwiftUI

public protocol TagRepositoryProtocol {
    //    func refresh()

    associatedtype TagsContainer: TagsContainerProtocol

    func makeTagsContainer() -> TagsContainer

    func addTag(_ tag: Tag)
}

public protocol TagsContainerProtocol: DataCollectionContainer<Tag, TagsContainerAction, TagsValueAction> { }

public enum TagsContainerAction {
    case delete(indices: IndexSet)

    case move(fromOffsets: IndexSet, toOffset: Int)
}

public enum TagsValueAction {
    case delete
}

// MARK: Mock implementation

public struct MockTagList: TagsContainerProtocol {
    @ObservedObject var storage: MockTagStorage

    public var data: [MockTagObject] { storage.tags }

    public let id = \MockTagObject.tag.id

    public func body(content: Content) -> some View {
        content
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                storage.tags.shuffle()
            }
    }

    public func container(element: MockTagObject) -> MockTagView {
        MockTagView(tag: element, actionHandler: handle(element:action:))
    }

    public func handle(action: Action) {
        switch action {
        case let .delete(indices):
            storage.tags.remove(atOffsets: indices)

        case let .move(fromOffsets, toOffset):
            storage.tags.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
    }

    func handle(element: MockTagObject, action: ValueAction) {
        switch action {
        case .delete:
            storage.tags.removeAll { $0 === element }
        }
    }
}

public struct MockTagView: DataValueContainer {
    @ObservedObject var tag: MockTagObject
    
    let actionHandler: (MockTagObject, TagsValueAction) -> Void

    public var element: Tag {
        tag.tag
    }

    public func body(content: Content) -> some View {
        content
    }
    
    public func handle(action: TagsValueAction) {
        actionHandler(tag, action)
    }
}

public final class MockTagObject: ObservableObject {
    @Published public var tag: Tag

    public init(tag: Tag) {
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

public final class MockTagRepository: TagRepositoryProtocol {
    let storage: MockTagStorage

    public init(tags: [Tag]) {
        self.storage = .init(tags: tags.map { .init(tag: $0) })
    }

    public func makeTagsContainer() -> some TagsContainerProtocol {
        MockTagList(storage: storage)
    }

    public func addTag(_ tag: Tag) {
        storage.tags.append(.init(tag: tag))
    }
}

final class MockTagStorage: ObservableObject {
    @Published var tags: [MockTagObject]

    init(tags: [MockTagObject]) {
        self.tags = tags
    }
}

struct TagsContainerView<Container: TagsContainerProtocol>: View {
    let container: Container

    var body: some View {
        container.view { value in
            VStack(alignment: .leading) {
                Text("VendedElement: \(value.element.id)")

                Text(value.element.state.uuidString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Button("Delete", role: .destructive) {
                    withAnimation {
                        value.handle(action: .delete)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .onDelete { indices in
            container.handle(action: .delete(indices: indices))
        }
        .onMove { fromOffsets, toOffset in
            container.handle(action: .move(fromOffsets: fromOffsets, toOffset: toOffset))
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static let repo = MockTagRepository(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    static var previews: some View {
        NavigationStack {
            List {
                TagsContainerView(container: repo.makeTagsContainer())
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif
            }
        }
    }
}
