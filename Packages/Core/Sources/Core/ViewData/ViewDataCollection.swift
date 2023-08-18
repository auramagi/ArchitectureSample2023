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

public struct WithViewDataCollection<Repository: ViewDataCollectionRepository, Content: View>: View {
    public typealias DataCollection = DataCollectionContent<Repository>

    let repository: Repository

    @ViewBuilder let content: (DataCollection) -> Content

    public init(_ repository: Repository, @ViewBuilder content: @escaping (DataCollection) -> Content) {
        self.repository = repository
        self.content = content
    }

    public var body: some View {
        InstalledModifierView(modifier: repository.makeCollection()) { viewDataCollection in
            content(
                .init(
                    repository: repository,
                    dataCollection: viewDataCollection
                )
            )
        }
        .modifier(repository.dataCollectionEnvironment)
    }
}

public struct DataCollectionContent<Repository: ViewDataCollectionRepository> {
    let repository: Repository

    let dataCollection: Repository.ViewDataCollectionType

    init(
        repository: Repository,
        dataCollection: Repository.ViewDataCollectionType
    ) {
        self.repository = repository
        self.dataCollection = dataCollection
    }

    @discardableResult
    public func handle(_ action: Repository.CollectionAction) -> Task<Void, Never>? {
        dataCollection.handle(action)
    }
}

extension ForEach {
    public init<Repository: ViewDataCollectionRepository, C: View>(
        _ collectionContent: DataCollectionContent<Repository>,
        @ViewBuilder content: @escaping (Repository.ViewDataType) -> C
    ) where Repository.ViewDataCollectionType.Data == Data, ID == Repository.ViewDataCollectionType.ID, Content == WithViewData<Repository, C> {
        self.init(
            collectionContent.dataCollection.data,
            id: collectionContent.dataCollection.id,
            content: { object in
                WithViewData(collectionContent.repository, object: object, content: content)
            }
        )
    }
}
