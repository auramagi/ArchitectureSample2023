//
//  ViewDataCollectionBuilder.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import SwiftUI

public protocol ViewDataCollectionBuilder<Entity, CollectionAction, Action>: ViewModifier {
    associatedtype Entity

    associatedtype CollectionAction

    associatedtype Action

    associatedtype Object

    associatedtype ViewDataCollectionType: ViewDataCollection where ViewDataCollectionType.Object == Object, ViewDataCollectionType.Action == CollectionAction

    func makeCollection() -> ViewDataCollectionType

    associatedtype ViewDataType: ViewData where ViewDataType.Entity == Entity, ViewDataType.Action == Action

    func makeData(object: Object) -> ViewDataType

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

public struct WithViewDataCollection<Builder: ViewDataCollectionBuilder, Content: View>: View {
    public typealias DataCollection = DataCollectionContent<Builder>

    let builder: Builder

    @ViewBuilder let content: (DataCollection) -> Content

    public init(_ builder: Builder, @ViewBuilder content: @escaping (DataCollection) -> Content) {
        self.builder = builder
        self.content = content
    }

    public var body: some View {
        InstalledModifierView(modifier: builder.makeCollection()) { container in
            content(
                .init(
                    data: { container.data },
                    id: container.id,
                    actionHandler: container.handle(_:),
                    makeData: builder.makeData(object:)
                )
            )
        }
        .modifier(builder)
    }
}

public struct InstalledModifierView<Modifier: DynamicViewContainer, Content: View>: View {
    let modifier: Modifier

    @ViewBuilder let content: (Modifier) -> Content

    public var body: some View {
        content(modifier)
            .modifier(modifier)
    }
}

public struct DataCollectionContent<Builder: ViewDataCollectionBuilder> {
    var data: () -> Builder.ViewDataCollectionType.Data

    let id: KeyPath<Builder.ViewDataCollectionType.Data.Element, Builder.ViewDataCollectionType.ID>

    let actionHandler: (Builder.CollectionAction) -> Task<Void, Never>?

    let makeData: (Builder.Object) -> Builder.ViewDataType

    init(
        data: @escaping () -> Builder.ViewDataCollectionType.Data,
        id: KeyPath<Builder.ViewDataCollectionType.Data.Element, Builder.ViewDataCollectionType.ID>,
        actionHandler: @escaping (Builder.CollectionAction) -> Task<Void, Never>?,
        makeData: @escaping (Builder.Object) -> Builder.ViewDataType
    ) {
        self.data = data
        self.id = id
        self.actionHandler = actionHandler
        self.makeData = makeData
    }

    @discardableResult
    public func handle(_ action: Builder.CollectionAction) -> Task<Void, Never>? {
        actionHandler(action)
    }
}

extension ForEach {
    public init<Builder: ViewDataCollectionBuilder, C: View>(
        _ collection: DataCollectionContent<Builder>,
        @ViewBuilder content: @escaping (Builder.ViewDataType) -> C
    ) where Builder.ViewDataCollectionType.Data == Data, ID == Builder.ViewDataCollectionType.ID, Content == InstalledModifierView<Builder.ViewDataType, C> {
        self.init(
            collection.data(),
            id: collection.id,
            content: { object in
                InstalledModifierView(modifier: collection.makeData(object)) { property in
                    content(property)
                }
            }
        )
    }
}
