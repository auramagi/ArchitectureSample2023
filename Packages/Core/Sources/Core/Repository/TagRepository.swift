//
//  TagRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Foundation
import SwiftUI

public protocol TagRepositoryProtocol {
    //    func refresh()

    associatedtype TagsContainer: TagsContainerProtocol

    func makeTagsContainer() -> TagsContainer

    func addTag(_ tag: Tag)
}


public protocol TagsContainerProtocol: DataCollectionContainer<Tag, TagsContainerAction> {
}

public enum TagsContainerAction {
    case delete(indices: IndexSet)

    case move(fromOffsets: IndexSet, toOffset: Int)
}

public protocol DataCollectionContainer<Value, Action>: DynamicProperty, ViewModifier {
    typealias InternalValue = Data.Element
    
    associatedtype Value
    
    associatedtype ID: Hashable

    associatedtype Data: RandomAccessCollection

    associatedtype ValueContainer: DataValueContainer<Value>

    associatedtype Action
    
    associatedtype Body: View = Content

    var id: KeyPath<Data.Element, ID> { get }

    var data: Data { get }

    func value(_ internalValue: InternalValue) -> ValueContainer

    func handle(action: Action)
    
    @ViewBuilder @MainActor func body(content: Content) -> Body
}

extension DataCollectionContainer where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}

extension DataCollectionContainer where Action == Void {
    public func handle(action: Action) { }
}

public protocol DataValueContainer<Value>: DynamicProperty, ViewModifier {
    associatedtype Value
    
    associatedtype Body: View = Content

    var element: Value { get }
}

extension DataValueContainer where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}

extension DataCollectionContainer {
    public func view(@ViewBuilder content: @escaping (Value) -> some View) -> some DynamicViewContent {
        DataCollectionContainerView(container: self, content: content)
    }
}

struct DataCollectionContainerView<Container: DataCollectionContainer, Content: View>: DynamicViewContent {
    let container: Container
    
    @ViewBuilder var content: (Container.Value) -> Content
    
    var data: Container.Data { container.data }
    
    var body: some View {
        ForEach(container.data, id: container.id) { element in
            DataValueContainerView(container: container.value(element), content: content)
        }
        .modifier(container)
    }
}

struct DataValueContainerView<Container: DataValueContainer, Content: View>: View {
    let container: Container
    
    let content: (Container.Value) -> Content
    
    var body: some View {
        content(container.element)
    }
}

import Combine

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

    public func value(_ internalValue: MockTagObject) -> MockTagView {
        MockTagView(tag: internalValue)
    }

    public func handle(action: Action) {
        switch action {
        case let .delete(indices):
            storage.tags.remove(atOffsets: indices)

        case let .move(fromOffsets, toOffset):
            storage.tags.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
    }
}

public struct MockTagView: DataValueContainer {
    @ObservedObject var tag: MockTagObject

    public var element: Tag {
        tag.tag
    }

    public func body(content: Content) -> some View {
        content
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
        container.view { element in
            VStack(alignment: .leading) {
                Text("VendedElement: \(element.id)")

                Text(element.state.uuidString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
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
