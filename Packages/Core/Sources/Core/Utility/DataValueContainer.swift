//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataValueContainer<Entity, Action>: DynamicViewContainer {
    // MARK: Primary associated Types

    associatedtype Entity
    
    // MARK: External value

    var element: Entity { get }
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
        InstalledModifierView(modifier: makeObjectCollectionContainer()) { container in
            collection(
                .init(
                    data: { container.data },
                    id: container.id,
                    actionHandler: container.handle(_:),
                    makeObjectContainer: makeObjectContainer(object:)
                )
            )
        }
        .modifier(self)
    }
}

struct InstalledModifierView<Modifier: DynamicViewContainer, Content: View>: View {
    let modifier: Modifier

    @ViewBuilder let content: (Modifier) -> Content

    var body: some View {
        content(modifier)
            .modifier(modifier)
    }
}

public protocol DynamicViewContainer: DynamicProperty, ViewModifier {
    associatedtype Action = Void

    func handle(_ action: Action) -> Task<Void, Never>?

    associatedtype Body: View = Content
    
    func body(content: Content) -> Body
}

extension DynamicViewContainer where Action == Void {
    public func handle(action: Action) -> Task<Void, Never>? {
        nil
    }
}

extension DynamicViewContainer {
    public func handle(_ action: Action) {
        _ = handle(action)
    }
}

extension DynamicViewContainer where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}

public struct BuilderCollection<Builder: ViewDataCollectionBuilder> {
    private var data: () -> Builder.ObjectCollectionContainer.Data
    
    private let id: KeyPath<Builder.ObjectCollectionContainer.Data.Element, Builder.ObjectCollectionContainer.ID>
    
    private let actionHandler: (Builder.CollectionAction) -> Task<Void, Never>?

    private let makeObjectContainer: (Builder.Object) -> Builder.ObjectProperty
    
    init(
        data: @escaping () -> Builder.ObjectCollectionContainer.Data,
        id: KeyPath<Builder.ObjectCollectionContainer.Data.Element, Builder.ObjectCollectionContainer.ID>,
        actionHandler: @escaping (Builder.CollectionAction) -> Task<Void, Never>?,
        makeObjectContainer: @escaping (Builder.Object) -> Builder.ObjectProperty
    ) {
        self.data = data
        self.id = id
        self.actionHandler = actionHandler
        self.makeObjectContainer = makeObjectContainer
    }

    public func forEach<Content: View>(@ViewBuilder content: @escaping (Builder.ObjectProperty) -> Content) -> some DynamicViewContent {
        ForEach(data(), id: id) { object in
            InstalledModifierView(modifier: makeObjectContainer(object)) { property in
                content(property)
            }
        }
    }

    @discardableResult
    public func handle(_ action: Builder.CollectionAction) -> Task<Void, Never>? {
        actionHandler(action)
    }
}
