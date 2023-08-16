//
//  RandomImageRequest.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

extension API {
    enum RandomImageRequest {
        enum Single {
            struct Get: APIRequest {
                typealias Message = URL
                
                let path = "breeds/image/random"
                
                let method = "GET"
                
            }
        }
        
        enum Multiple {
            struct Get: APIRequest {
                typealias Message = [URL]
                
                var path: String { "breeds/image/random/\(count)" }
                
                let method = "GET"
                
                let count: Int
            }
        }
    }
}
