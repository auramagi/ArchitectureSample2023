//
//  LoadingState.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public enum LoadingState<Success> {
    case notStarted

    case loading

    case loaded(Result<Success, Error>)

    public var result: Result<Success, Error>? {
        switch self {
        case .notStarted, .loading:
            return nil

        case let .loaded(result):
            return result
        }
    }

    public var isLoaded: Bool {
        result != nil
    }
}
