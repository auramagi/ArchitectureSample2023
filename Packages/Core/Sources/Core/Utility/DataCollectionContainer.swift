//
//  DataCollectionContainer.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol DataCollectionContainer: DynamicViewContainer {
    // MARK: Primary associated Types
    
    associatedtype Object
    
    // MARK: Internal storage representation
    
    associatedtype Data: RandomAccessCollection where Data.Element == Object
    
    associatedtype ID: Hashable
    
    var data: Data { get }
    
    var id: KeyPath<Object, ID> { get }
}
