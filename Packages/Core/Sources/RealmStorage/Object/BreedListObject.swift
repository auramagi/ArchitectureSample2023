//
//  BreedListObject.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/18.
//

import Core
import Foundation
import RealmSwift

public final class BreedListObject: Object, ObjectKeyIdentifiable {
    @Persisted public var breeds: List<BreedListItemObject>
}
