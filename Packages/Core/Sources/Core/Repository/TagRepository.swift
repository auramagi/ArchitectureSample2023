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

public final class MockTagRepository: TagRepositoryProtocol {
    let storage: MockTagStorage

    init(tags: [Tag]) {
        self.storage = .init(tags: tags.map { .init(tag: $0) })
    }

    public func makeTagsContainer() -> some TagsContainerProtocol {
        MockTagList(storage: storage)
    }

    public func addTag(_ tag: Tag) {
        storage.tags.append(.init(tag: tag))
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

struct MockTagList: TagsContainerProtocol {
    @ObservedObject var storage: MockTagStorage

    var data: [MockTagObject] { storage.tags }

    let id = \MockTagObject.tag.id

    func body(content: Content) -> some View {
        content
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                storage.tags.shuffle()
            }
    }

    func container(element: MockTagObject) -> MockTagView {
        MockTagView(tag: element, actionHandler: handle(element:action:))
    }

    func handle(action: Action) {
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

struct MockTagView: DataValueContainer {
    @ObservedObject var tag: MockTagObject
    
    let actionHandler: (MockTagObject, TagsValueAction) -> Void

    var element: Tag {
        tag.tag
    }

    func body(content: Content) -> some View {
        content
    }
    
    func handle(action: TagsValueAction) {
        actionHandler(tag, action)
    }
}

final class MockTagObject: ObservableObject {
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
    static let repo: some TagRepositoryProtocol = .mock(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    
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
