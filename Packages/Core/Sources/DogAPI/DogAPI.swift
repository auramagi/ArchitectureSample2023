//
//  DogAPI.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Core
import Foundation

public final class APIClient {
    public struct Configuration {
        let baseURL: URL

        public init(baseURL: URL) {
            self.baseURL = baseURL
        }
    }

    let session: URLSession

    let configuration: Configuration

    public init(session: URLSession, configuration: Configuration) {
        self.session = session
        self.configuration = configuration
    }

    func execute<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, _) = try await session.data(for: request.makeURLRequest(configuration: configuration))
        return try request.decode(data: data)
    }
}

public struct APIResponse<Message: Decodable>: Decodable {
    public let message: Message

    public let status: String
}

enum RandomDogRequest {
    struct Get: APIRequest {
        let path = "breeds/image/random"

        let method = "GET"

        typealias Message = URL
    }
}

protocol APIRequest {
    associatedtype Message: Decodable

    typealias Response = APIResponse<Message>

    var path: String { get }

    var method: String { get }
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

public typealias APIDogRepository = APIClient

extension APIDogRepository: DogRepositoryProtocol {
    public func getRandomDog() async throws -> URL {
        try await execute(RandomDogRequest.Get()).message
    }
}
