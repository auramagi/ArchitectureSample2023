//
//  DataValueContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewData<Entity, Action>: DynamicProperty, ViewModifier {
    associatedtype Entity

    associatedtype Action

    var entity: Entity { get }

    @discardableResult
    func handle(_ action: Action) -> Task<Void, Never>?
}

public extension ViewData where Action == Void {
    // Define an alias for better autocompletion when overriding with a custom implementation
    typealias DefaultAction = Void

    func handle(_ action: DefaultAction) -> Task<Void, Never>? {
        nil
    }
}

public extension ViewData where Body == Content {
    // Define an alias for better autocompletion when overriding with a custom implementation
    typealias DefaultContent = Content

    func body(content: Content) -> DefaultContent {
        content
    }
}
