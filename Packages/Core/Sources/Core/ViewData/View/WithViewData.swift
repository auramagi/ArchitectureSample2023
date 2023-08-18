//
//  WithViewData.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import SwiftUI

public struct WithViewData<Repository: ViewDataRepository, Content: View>: View {
    let repository: Repository

    let object: Repository.Object

    let content: (Repository.ViewDataType) -> Content

    public init(_ repository: Repository, object: Repository.Object, @ViewBuilder content: @escaping (Repository.ViewDataType) -> Content) {
        self.repository = repository
        self.object = object
        self.content = content
    }

    public var body: some View {
        InstalledModifierView(modifier: repository.makeData(object: object)) { viewData in
            content(viewData)
        }
        .modifier(repository.dataEnvironment)
    }
}

extension WithViewData where Repository.Object == Void {
    public init(_ repository: Repository, @ViewBuilder content: @escaping (Repository.ViewDataType) -> Content) {
        self.repository = repository
        self.object = ()
        self.content = content
    }
}
