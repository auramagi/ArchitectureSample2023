//
//  ViewDataCollection.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewDataCollection: DynamicViewContainer {
    associatedtype Object
    
    associatedtype Data: RandomAccessCollection where Data.Element == Object
    
    associatedtype ID: Hashable
    
    var data: Data { get }
    
    var id: KeyPath<Object, ID> { get }
}

public protocol ViewDataCollectionRepository<Entity, CollectionAction, Action>: ViewDataRepository {
    associatedtype CollectionAction

    associatedtype ViewDataCollectionType: ViewDataCollection where ViewDataCollectionType.Object == Object, ViewDataCollectionType.Action == CollectionAction

    func makeCollection() -> ViewDataCollectionType

    associatedtype DataCollectionEnvironment: ViewModifier = EmptyModifier
    var dataCollectionEnvironment: DataCollectionEnvironment { get }
}

public extension ViewDataCollectionRepository where DataCollectionEnvironment == EmptyModifier {
    var dataCollectionEnvironment: EmptyModifier {
        .identity
    }
}

public struct WithViewDataCollection<Builder: ViewDataCollectionRepository, Content: View>: View {
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
        .modifier(builder.dataCollectionEnvironment)
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

public struct DataCollectionContent<Builder: ViewDataCollectionRepository> {
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
    public init<Builder: ViewDataCollectionRepository, C: View>(
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
