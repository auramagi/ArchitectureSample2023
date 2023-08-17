//
//  ViewDataCollection.swift
//  
//
//  Created by Mikhail Apurin on 13.08.2023.
//

import SwiftUI

public protocol ViewDataCollection: DynamicViewContainer {
    associatedtype Object
    
    associatedtype Data: RandomAccessCollection where Data.Element == Object
    
    associatedtype ID: Hashable
    
    var data: Data { get }
    
    var id: KeyPath<Object, ID> { get }
}
