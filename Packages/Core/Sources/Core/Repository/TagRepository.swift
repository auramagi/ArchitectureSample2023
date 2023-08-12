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

    associatedtype TagList: ViewDataProvider<Tag>

    func makeTagList() -> TagList

}

public protocol ViewDataProvider<VendedElement>: DynamicProperty, ViewModifier {
    associatedtype Data: RandomAccessCollection

    associatedtype ID: Hashable

    associatedtype VendedElement

    associatedtype VendedElementProvider: ViewDataElementProvider<VendedElement>

    var id: KeyPath<Data.Element, ID> { get }

    var data: Data { get }

    func map(_ element: Data.Element) -> VendedElementProvider
}

public protocol ViewDataElementProvider<VendedElement>: DynamicProperty, ViewModifier {
    associatedtype VendedElement

    var element: VendedElement { get }
}

extension ViewDataProvider {
    public func callAsFunction(@ViewBuilder content: @escaping (VendedElement) -> some View) -> some View {
        ViewDataConsumer(provider: self, content: content)
    }
}

struct ViewDataConsumer<Provider: ViewDataProvider, Content: View>: View {
    let provider: Provider

    @ViewBuilder var content: (Provider.VendedElement) -> Content

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

public struct MockTagList: ViewDataProvider {
    public typealias Data = [MockTagObject]

    public typealias ID = String

    public typealias VendedElement = Tag

    public typealias VendedElementProvider = MockTagView

    @State public var data: [MockTagObject]

    public let id: KeyPath<MockTagObject, String> = \MockTagObject.tag.id

    init(data: [Tag]) {
        self.data = data.map { .init(tag: $0) }
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                data.shuffle()
            }
    }

    public func map(_ element: MockTagObject) -> MockTagView {
        MockTagView(tag: element)
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

public final class MockTagObject: ObservableObject, Identifiable {
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
    var tags: [Tag]

    public init(tags: [Tag]) {
        self.tags = tags
    }

//    public func makeTagList<C: View>(@ViewBuilder content: @escaping (Tag) -> C) -> AnyView {
//        MockTagList(tags: tags, content: content).asAnyView()
//    }

//    public typealias Container = MockTagList

//    public func makeTagList<C: View>(content: @escaping (Tag) -> C) -> ViewContainerBuilder<MockTagList<C>, C> where C == Container<C>.ContentView {

    public func makeTagList() -> some ViewDataProvider<Tag> {
        MockTagList(data: tags)
    }
}

public extension View {
    func asAnyView() -> AnyView {
        .init(self)
    }
}

struct CustVM: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

public protocol ViewContainer: DynamicProperty {
    associatedtype Body: View

    associatedtype Element

    typealias Content<Element> = MyViewModifier_Content<Self>

    @ViewBuilder func body(content: Content<Element>) -> Body
}

public struct MyViewModifier_Content<Container: ViewContainer> {
//    private let content: (Element) -> ContentView.ContentView

    init<ContentView>(content: @escaping (Container.Element) -> ContentView) {
//        self.content = content
    }

    func callAsFunction(_ element: Container.Element) -> some View {
//        content(element)
        let x = Text("A") as (any View)

        return x.asAnyView()
    }
}

struct SampleModifier<ContentView: View>: ViewContainer {
    typealias Element = Int

    @State var base = 0

    func body(content: Content<Int>) -> some View {
        ForEach(0...10, id: \.self) { i in
            HStack {
                content(i)
                Spacer()
                Button("\(base)") {
                    base += 1
                }
            }
        }
    }
}

public struct ViewContainerBuilder<Container: ViewContainer, ContentView: View>: View {
    let container: Container

    @ViewBuilder let content: (Container.Element) -> ContentView

    public var body: Never { fatalError() }

    typealias Proxy = _ViewContainerBuilder<Container, ContentView>

    public static func _makeView(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewInputs) -> SwiftUI._ViewOutputs {
        let testViewProvider: (Int) -> Text = {
            Text("ABC: \($0, format: .number)")
        }

        let testView = testViewProvider(1)

        let result = Proxy._makeView(view: unsafeBitCast(view, to: SwiftUI._GraphValue<Proxy>.self), inputs: inputs)
        print(#function, result)
        return result
    }

    public static func _makeViewList(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewListInputs) -> SwiftUI._ViewListOutputs {
        let result = Proxy._makeViewList(view: unsafeBitCast(view, to: SwiftUI._GraphValue<Proxy>.self), inputs: inputs)
        print(#function, view, result)
        print(
            Mirror(reflecting:
                    (Mirror(reflecting: view).children.map(\.value) as? [Any])!.first!
                  ).children.map(\.value)
        )
        print(inputs)
        print(Mirror(reflecting: result).children.map(\.value))
        return result
    }

    public static func _viewListCount(inputs: SwiftUI._ViewListCountInputs) -> Swift.Int? {
        let result = Proxy._viewListCount(inputs: inputs)
        print(#function, result)
        return result
    }
}

struct _ViewContainerBuilder<Container: ViewContainer, ContentView: View>: View {
    let container: Container

    @ViewBuilder let content: (Container.Element) -> ContentView

    public var body: some View {
//        container.body(content: .init(content: content))
        Text("fff")
    }
}

struct MyView: View {
    var body: some View {
        List {
            ViewContainerBuilder(container: SampleModifier<Text>()) { i in
                Text("Number: \(i)")
            }
        }
    }
}

struct InjectedView<Repository: TagRepositoryProtocol>: View {
    let repository: Repository

    var body: some View {
        repository.makeTagList().callAsFunction { element in
            VStack(alignment: .leading) {
                Text("VendedElement: \(element.id)")

                Text(element.state.uuidString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
//        MyView()
        VStack {
            InjectedView(repository: MockTagRepository(tags: [.init(name: "1"), .init(name: "2"), .init(name: "3")]))
        }
    }
}
