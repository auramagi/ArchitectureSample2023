//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataValueContainer<Entity, Action>: DynamicProperty, ViewModifier {
    // MARK: Primary associated Types

    associatedtype Entity
    
    associatedtype Action = Void
    
    // MARK: External value

    var element: Entity { get }
    
    // MARK: External action support
    
    func handle(_ action: Action)
    
    // MARK: ViewModifier support
    
    associatedtype Body: View = Content
    
    // We redefine this to be able to provide an empty implementation in an extension
    @ViewBuilder @MainActor func body(content: Content) -> Body
}

extension DataValueContainer where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}

extension DataValueContainer where Action == Void {
    public func handle(action: Action) { }
}

public protocol ViewDataCollectionBuilder<Entity, CollectionAction, ObjectAction>: ViewModifier {
    associatedtype Entity

    associatedtype CollectionAction

    associatedtype ObjectAction

    associatedtype Object

    associatedtype ObjectCollectionContainer: DataCollectionContainer where ObjectCollectionContainer.Object == Object, ObjectCollectionContainer.Action == CollectionAction

    func makeObjectCollectionContainer() -> ObjectCollectionContainer

    associatedtype ObjectProperty: DataValueContainer where ObjectProperty.Entity == Entity, ObjectProperty.Action == ObjectAction

    func makeObjectContainer(object: Object) -> ObjectProperty

    // MARK: ViewModifier support

    associatedtype Body: View = Content

    // We redefine this to be able to provide an empty implementation in an extension
    @ViewBuilder @MainActor func body(content: Content) -> Body
}

extension ViewDataCollectionBuilder where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}

extension ViewDataCollectionBuilder {
    public typealias Collection = BuilderCollection<Self>

    @ViewBuilder public func build<ContentView: View>(@ViewBuilder collection: @escaping (Collection) -> ContentView) -> some View {
        InstalledModifierView(modifier: makeObjectCollectionContainer()) { collectionContainer in
            collection(.init(container: collectionContainer, makeObjectContainer: makeObjectContainer(object:)))
        }
    }
}

struct InstalledModifierView<Modifier: DynamicProperty & ViewModifier, Content: View>: View {
    let modifier: Modifier

    @ViewBuilder let content: (Modifier) -> Content

    var body: some View {
        content(modifier)
            .modifier(modifier)
    }
}

public struct BuilderCollection<Builder: ViewDataCollectionBuilder> {
    let container: Builder.ObjectCollectionContainer

    let makeObjectContainer: (Builder.Object) -> Builder.ObjectProperty

    public func forEach<Content: View>(@ViewBuilder content: @escaping (Builder.ObjectProperty) -> Content) -> some DynamicViewContent {
        DataCollectionContainerView(container: container) { object in
            InstalledModifierView(modifier: makeObjectContainer(object)) { property in
                content(property)
            }
        }
        .modifier(container)
    }

    public func handle(_ action: Builder.CollectionAction) {
        container.handle(action: action)
    }
}

struct DataCollectionContainerView<Container: DataCollectionContainer, Content: View>: DynamicViewContent {
    let container: Container

    @ViewBuilder var content: (Container.Object) -> Content

    init(container: Container, @ViewBuilder content: @escaping (Container.Object) -> Content) {
        self.container = container
        self.content = content
    }

    var data: Container.Data { container.data }

    var body: some View {
        ForEach(container.data, id: container.id) { object in
            content(object)
        }
        .modifier(container)
    }
}
