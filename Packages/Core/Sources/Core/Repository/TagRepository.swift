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

    associatedtype TagList: TagListProviderProtocol

    func makeTagList() -> TagList

    func addTag(_ tag: Tag)
}


public protocol TagListProviderProtocol: ViewDataProvider<Tag> where Action == TagListAction {

}

public enum TagListAction {
    case delete(indices: IndexSet)

    case move(fromOffsets: IndexSet, toOffset: Int)
}

public protocol ViewDataProvider<VendedElement>: DynamicProperty, ViewModifier {
    associatedtype Data: RandomAccessCollection

    associatedtype ID: Hashable

    associatedtype VendedElement

    associatedtype VendedElementProvider: ViewDataElementProvider<VendedElement>

    associatedtype Action = Void

    var id: KeyPath<Data.Element, ID> { get }

    var data: Data { get }

    func map(_ element: Data.Element) -> VendedElementProvider

    func handle(action: Action)
}

extension ViewDataProvider where Action == Void {
    public func handle(action: Action) { }
}

public protocol ViewDataElementProvider<VendedElement>: DynamicProperty, ViewModifier {
    associatedtype VendedElement

    var element: VendedElement { get }
}

extension ViewDataProvider {
    public func view(@ViewBuilder content: @escaping (VendedElement) -> some View) -> some DynamicViewContent {
        ViewDataConsumer(provider: self, content: content)
    }
}

struct ViewDataConsumer<Provider: ViewDataProvider, Content: View>: View, DynamicViewContent {
    let provider: Provider

    @ViewBuilder var content: (Provider.VendedElement) -> Content

    var data: Provider.Data { provider.data }

    var body: some View {
        ForEach(provider.data, id: provider.id) { element in
            ElementView(provider: provider.map(element), content: content)
        }
        .modifier(provider)
    }

    struct ElementView: View {
        let provider: Provider.VendedElementProvider

        let content: (Provider.VendedElement) -> Content

        var body: some View {
            content(provider.element)
        }
    }
}

import Combine

public struct MockTagList: TagListProviderProtocol {
    @ObservedObject var storage: MockTagStorage

    public var data: [MockTagObject] { storage.tags }

    public let id = \MockTagObject.tag.id

    public func body(content: Content) -> some View {
        content
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                storage.tags.shuffle()
            }
    }

    public func map(_ element: MockTagObject) -> MockTagView {
        MockTagView(tag: element)
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

public struct MockTagView: ViewDataElementProvider {
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

    public func makeTagList() -> some TagListProviderProtocol {
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

struct TagList<Provider: TagListProviderProtocol>: View {
    let provider: Provider

    var body: some View {
        provider.view { element in
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
            provider.handle(action: .delete(indices: indices))
        }
        .onMove { fromOffsets, toOffset in
            provider.handle(action: .move(fromOffsets: fromOffsets, toOffset: toOffset))
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static let repo = MockTagRepository(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")])
    static var previews: some View {
        NavigationStack {
            List {
                TagList(provider: repo.makeTagList())
            }
            .toolbar {
                EditButton()
            }
        }
    }
}
