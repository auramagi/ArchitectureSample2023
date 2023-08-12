//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataValueContainer<Value, Action>: DynamicProperty, ViewModifier {
    // MARK: Primary associated Types

    associatedtype Value
    
    associatedtype Action = Void
    
    // MARK: External value

    var element: Value { get }
    
    // MARK: External action support
    
    func handle(action: Action)
    
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

struct DataCollectionContainerView<Container: DataCollectionContainer, Content: View>: DynamicViewContent {
    let container: Container
    
    @ViewBuilder var content: (Container.ValueContainer) -> Content
    
    var data: Container.Data { container.data }
    
    var body: some View {
        ForEach(container.data, id: container.id) { element in
            DataValueContainerView(
                container: container.container(element: element),
                content: content
            )
        }
        .modifier(container)
    }
}
