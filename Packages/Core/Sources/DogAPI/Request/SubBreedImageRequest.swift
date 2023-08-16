//
//  SubBreedImageRequest.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

extension API {
    enum SubBreedImageRequest {
        enum All {
            struct Get: APIRequest {
                typealias Message = [URL]

                var path: String { "breed/\(breed)/\(subBreed)/images" }

                let method = "GET"

                let breed: Breed

                let subBreed: SubBreed
            }
        }

        enum Random {
            enum Single {
                struct Get: APIRequest {
                    typealias Message = URL

                    var path: String { "breed/\(breed)/\(subBreed)/images/random" }

                    let method = "GET"

                    let breed: Breed

                    let subBreed: SubBreed
                }
            }

            enum Multiple {
                struct Get: APIRequest {
                    typealias Message = [URL]

                    var path: String { "breed/\(breed)/\(subBreed)/images/random/\(count)" }

                    let method = "GET"

                    let breed: Breed

                    let subBreed: SubBreed

                    let count: Int
                }
            }
        }
    }
}
