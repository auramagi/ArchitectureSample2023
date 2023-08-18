//
//  ViewDataRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public protocol ViewDataRepository<Object, Entity, Action> {
    associatedtype Object

    associatedtype Entity

    associatedtype Action

    associatedtype ViewDataType: ViewData where ViewDataType.Entity == Entity, ViewDataType.Action == Action

    func makeData(object: Object) -> ViewDataType

    associatedtype DataEnvironment: ViewModifier
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
