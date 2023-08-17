//
//  TagObject.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/02.
//

import Core
import RealmSwift
import SwiftUI

public final class TagObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var name: String
}

extension Tag {
    init(object: TagObject) {
        if object.isInvalidated {
            self.init(name: "Invalidated object")
        } else {
            self.init(name: object.name)
        }
    }
}
