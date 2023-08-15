//
//  DataCollectionContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataCollectionContainer: MyModifier {
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
}

extension DataCollectionContainer where Action == Void {
    public func handle(action: Action) { }
}
