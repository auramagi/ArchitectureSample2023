//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataValueContainer<Entity, Action>: MyModifier {
    // MARK: Primary associated Types

    associatedtype Entity
    
    associatedtype Action = Void
    
    // MARK: External value

    var element: Entity { get }
    
    // MARK: External action support
    
    func handle(_ action: Action)
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
        InstalledModifierView(modifier: makeObjectCollectionContainer()) { container in
            collection(
                .init(
                    data: { container.data },
                    id: container.id,
                    actionHandler: container.handle(action:),
                    makeObjectContainer: makeObjectContainer(object:)
                )
            )
        }
        .modifier(self)
    }
}

struct InstalledModifierView<Modifier: MyModifier, Content: View>: View {
    let modifier: Modifier

    @ViewBuilder let content: (Modifier) -> Content

    var body: some View {
        content(modifier)
            .modifier(modifier)
    }
}

public protocol MyModifier: DynamicProperty, ViewModifier {
    associatedtype Body: View = Content
    
    func body(content: Content) -> Body
}

extension MyModifier where Body == Content {
    public func body(content: Content) -> Body {
        content
    }
}


public struct BuilderCollection<Builder: ViewDataCollectionBuilder> {
    private var data: () -> Builder.ObjectCollectionContainer.Data
    
    private let id: KeyPath<Builder.ObjectCollectionContainer.Data.Element, Builder.ObjectCollectionContainer.ID>
    
    private let actionHandler: (Builder.CollectionAction) -> Void

    private let makeObjectContainer: (Builder.Object) -> Builder.ObjectProperty
    
    init(
        data: @escaping () -> Builder.ObjectCollectionContainer.Data,
        id: KeyPath<Builder.ObjectCollectionContainer.Data.Element, Builder.ObjectCollectionContainer.ID>,
        actionHandler: @escaping (Builder.CollectionAction) -> Void,
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

    public func handle(_ action: Builder.CollectionAction) {
        actionHandler(action)
    }
}
