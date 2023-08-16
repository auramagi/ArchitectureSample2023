//
//  Collection+.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

extension Collection where Element: Identifiable {
    public func contains(id: Element.ID) -> Bool {
        contains { $0.id == id }
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    public mutating func removeAll(id: Element.ID) {
        removeAll { $0.id == id }
    }
}
