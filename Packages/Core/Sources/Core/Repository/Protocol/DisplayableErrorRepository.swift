//
//  DisplayableErrorRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol DisplayableErrorRepository {
    var error: AsyncStream<DisplayableError> { get }

    func sendError(_ error: DisplayableError) async

    func clearError(id: DisplayableError.ID)
}
