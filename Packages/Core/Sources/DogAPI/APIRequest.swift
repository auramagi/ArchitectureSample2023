//
//  APIRequest.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

protocol APIRequest {
    associatedtype Message: Decodable

    typealias Response = APIResponse<Message>

    var path: String { get }

    var method: String { get }

    func makeURLRequest(configuration: APIClient.Configuration) -> URLRequest

    func decode(data: Data) throws -> Response
}

extension APIRequest {
    func makeURLRequest(configuration: APIClient.Configuration) -> URLRequest {
        let url = configuration.baseURL.appending(path: path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }

    func decode(data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}
