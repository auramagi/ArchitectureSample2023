//
//  ViewDataCollectionRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public protocol ViewDataCollectionRepository<Entity, CollectionAction, Action>: ViewDataRepository {
    associatedtype CollectionAction

    associatedtype ViewDataCollectionType: ViewDataCollection where ViewDataCollectionType.Object == Object, ViewDataCollectionType.Action == CollectionAction

    func makeCollection() -> ViewDataCollectionType

    associatedtype DataCollectionEnvironment: ViewModifier
    var dataCollectionEnvironment: DataCollectionEnvironment { get }
}

public extension ViewDataCollectionRepository where DataCollectionEnvironment == EmptyModifier {
    var dataCollectionEnvironment: EmptyModifier {
        .identity
    }
}
