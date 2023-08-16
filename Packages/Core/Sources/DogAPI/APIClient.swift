//
//  APIClient.swift
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
