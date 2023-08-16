//
//  BreedListRequest.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

extension API {
    enum BreedListRequest {
        struct Get: APIRequest {
            typealias Message = BreedList

            let path = "breeds/list/all"

            let method = "GET"
        }
    }
}
