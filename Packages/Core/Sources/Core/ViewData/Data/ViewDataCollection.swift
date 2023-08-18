//
//  ViewDataCollection.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewDataCollection<Object, Action>: DynamicProperty, ViewModifier {
    associatedtype Object
    
    associatedtype Data: RandomAccessCollection where Data.Element == Object
    
    associatedtype ID: Hashable

    associatedtype Action
    
    var data: Data { get }
    
    var id: KeyPath<Object, ID> { get }

    @discardableResult
    func handle(_ action: Action) -> Task<Void, Never>?
}

public extension ViewDataCollection where Action == Void {
    // Define an alias for better autocompletion when overriding with a custom implementation
    typealias DefaultAction = Void

    func handle(_ action: DefaultAction) -> Task<Void, Never>? {
        nil
    }
}

public extension ViewDataCollection where Body == Content {
    // Define an alias for better autocompletion when overriding with a custom implementation
    typealias DefaultContent = Content

    func body(content: Content) -> DefaultContent {
        content
    }
}

