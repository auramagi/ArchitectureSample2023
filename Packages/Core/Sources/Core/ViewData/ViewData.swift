//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewData<Entity, Action>: DynamicViewContainer {
    associatedtype Entity

    var entity: Entity { get }
}

public protocol ViewDataRepository<Object, Entity, Action> {
    associatedtype Object = Void

    associatedtype Entity

    associatedtype Action

    associatedtype ViewDataType: ViewData where ViewDataType.Entity == Entity, ViewDataType.Action == Action

    func makeData(object: Object) -> ViewDataType

    associatedtype DataEnvironment: ViewModifier = EmptyModifier
    var dataEnvironment: DataEnvironment { get }
}

public extension ViewDataRepository where Object == Void {
    func makeData() -> ViewDataType {
        makeData(object: ())
    }
}

public extension ViewDataRepository where DataEnvironment == EmptyModifier {
    var dataEnvironment: EmptyModifier {
        .identity
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
