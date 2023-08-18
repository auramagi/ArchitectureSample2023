//
//  CoreDisplayableErrorRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import Combine
import Foundation

public final class CoreDisplayableErrorRepository: DisplayableErrorRepository {
    let errors: CurrentValueSubject<[DisplayableError], Never>

    public init(errors: [DisplayableError]) {
        self.errors = .init(errors)
    }

    public var error: AsyncStream<DisplayableError> {
        var iterator = errors.values.compactMap(\.first).makeAsyncIterator()
        return .init { await iterator.next() }
    }

    public func sendError(_ error: DisplayableError) async {
        errors.value.append(error)
        _ = await errors.values.first { !$0.contains(id: error.id) }
    }

    public func clearError(id: DisplayableError.ID) {
        errors.value.removeAll(id: id)
    }
}
