//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewData<Entity, Action>: DynamicViewContainer {
    // MARK: Primary associated Types

    associatedtype Entity
    
    // MARK: External value

    var element: Entity { get }
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
