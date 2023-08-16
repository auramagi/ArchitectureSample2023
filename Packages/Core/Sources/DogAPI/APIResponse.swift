//
//  APIResponse.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public struct APIResponse<Message: Decodable>: Decodable {
    public let message: Message

    public let status: String
}
