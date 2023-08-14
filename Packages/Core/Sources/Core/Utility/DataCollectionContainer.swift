//
//  DataCollectionContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataCollectionContainer: DynamicProperty, ViewModifier {
    // MARK: Primary associated Types

    associatedtype Object
    
    associatedtype Action

    // MARK: Internal storage representation

    associatedtype Data: RandomAccessCollection where Data.Element == Object

    associatedtype ID: Hashable
    
    var data: Data { get }
    
    var id: KeyPath<Object, ID> { get }

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
