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
    associatedtype TagResolver: ContentResolverProtocol where TagResolver.ConvertedContent == Tag

    func makeResolver() -> TagResolver
}

extension TagRepositoryProtocol {
    public func makeTagList<C: View>(@ViewBuilder content: @escaping (Tag) -> C) -> TypedForEach<TagResolver, C> {
        TypedForEach(resolver: makeResolver(), row: content)
    }
}

public protocol ContentResolverProtocol: DynamicProperty {
    associatedtype Content: Identifiable

    associatedtype ConvertedContent

    associatedtype ContentCollection: RandomAccessCollection where ContentCollection.Element == Content

    func body() -> ContentCollection

    func map(_ content: Content) -> ConvertedContent
}

public struct TypedForEach<Resolver: ContentResolverProtocol, Row: View>: View {
    let resolver: Resolver

    @ViewBuilder var row: (Resolver.ConvertedContent) -> Row

    public var body: some View {
        ForEach(resolver.body()) { content in
            row(resolver.map(content))
        }
    }
}

public struct MockTagResolver: ContentResolverProtocol {
    var tags: [Tag]

    public func body() -> [Tag] {
        tags
    }

    public func map(_ content: Tag) -> Tag {
        content
    }
}

public final class MockTagRepository: TagRepositoryProtocol {
    var tags: [Tag]

    public init(tags: [Tag]) {
        self.tags = tags
    }

    public func makeResolver() -> MockTagResolver {
        MockTagResolver(tags: tags)
    }
}
