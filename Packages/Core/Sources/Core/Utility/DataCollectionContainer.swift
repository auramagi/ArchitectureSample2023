//
//  DataCollectionContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataCollectionContainer<Value, Action, ValueAction>: DynamicProperty, ViewModifier {
    // MARK: Primary associated Types

    associatedtype Value
    
    associatedtype Action
    
    associatedtype ValueAction
    
    // MARK: Internal storage representation

    associatedtype Data: RandomAccessCollection
    
    typealias DataElement = Data.Element

    associatedtype DataElementID: Hashable
    
    var data: Data { get }
    
    var id: KeyPath<Data.Element, DataElementID> { get }
    
    // MARK: External value container

    associatedtype ValueContainer: DataValueContainer<Value, ValueAction>
    
    func container(element: DataElement) -> ValueContainer
    
    // MARK: External action support
    
    func handle(action: Action)

    // MARK: ViewModifier support
    
    associatedtype Body: View = Content

    // We redefine this to be able to provide an empty implementation in an extension
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

extension DataCollectionContainer {
    public func view(@ViewBuilder content: @escaping (ValueContainer) -> some View) -> some DynamicViewContent {
        DataCollectionContainerView(container: self, content: content)
    }
}

struct DataValueContainerView<Container: DataValueContainer, Content: View>: View {
    let container: Container
    
    let content: (Container) -> Content
    
    var body: some View {
        content(container)
            .modifier(container)
    }
}
