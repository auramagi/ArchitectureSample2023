//
//  MockDisplayableErrorRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import Foundation

extension DisplayableErrorRepository where Self: CoreDisplayableErrorRepository {
    public static func mock(errors: [DisplayableError] = []) -> Self {
        .init(errors: errors)
    }
}
