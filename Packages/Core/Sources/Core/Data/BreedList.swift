//
//  BreedList.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public typealias BreedList = [Breed: [SubBreed]]

extension BreedList {
    public static var mock: Self {
        [
            "affenpinscher": [],
            "african": [],
            "airedale": [],
            "akita": [],
            "appenzeller": [],
            "australian": [
                "shepherd"
            ],
        ]
    }
}
