//
//  BreedImageRequest.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

extension API {
    enum BreedImageRequest {
        enum All {
            struct Get: APIRequest {
                typealias Message = [URL]

                var path: String { "breed/\(breed)/images" }

                let method = "GET"

                let breed: Breed
            }
        }

        enum Random {
            enum Single {
                struct Get: APIRequest {
                    typealias Message = URL

                    var path: String { "breed/\(breed)/images/random" }

                    let method = "GET"

                    let breed: Breed
                }
            }

            enum Multiple {
                struct Get: APIRequest {
                    typealias Message = [URL]

                    var path: String { "breed/\(breed)/images/random/\(count)" }

                    let method = "GET"

                    let breed: Breed

                    let count: Int
                }
            }
        }
    }
}
