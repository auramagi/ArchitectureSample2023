//
//  TagRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Foundation
import SwiftUI

public protocol TagRepositoryProtocol {
    //    func refresh()

    func makeTagList<C: View>(@ViewBuilder content: @escaping (Tag) -> C) -> AnyView
}

public struct MockTagList<Content: View>: View {
    var tags: [Tag]

    var content: (Tag) -> Content

    public var body: some View {
        ForEach(tags) { tag in
            content(tag)
        }
    }
}

public final class MockTagRepository: TagRepositoryProtocol {
    var tags: [Tag]

    public init(tags: [Tag]) {
        self.tags = tags
    }

    public func makeTagList<C: View>(@ViewBuilder content: @escaping (Tag) -> C) -> AnyView {
        MockTagList(tags: tags, content: content).asAnyView()
    }
}

public extension View {
    func asAnyView() -> AnyView {
        .init(self)
    }
}
