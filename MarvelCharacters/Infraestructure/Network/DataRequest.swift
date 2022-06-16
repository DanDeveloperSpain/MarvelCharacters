//
//  DataRequest.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response

    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }

    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {

    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Response.self, from: data)
        return decoded
    }
}

extension DataRequest {

    var headers: [String: String] {
        [:]
    }

    var queryItems: [String: String] {
        [:]
    }
}

extension DataRequest {

    /// Helper to build the base parameters for the Api.
    /// - Returns: Array with apikey, ts and hash.
    func getBaseParameters() -> [String: String] {
        let currentTimeStamp = Int(Date().timeIntervalSince1970)

        let has = Encryption.md5Hash("\(currentTimeStamp)" + AppConfiguration().privateKey + AppConfiguration().publicKey)

        let parameters: [String: String] = [
            "apikey" : AppConfiguration().publicKey,
            "ts" : String(currentTimeStamp),
            "hash" :  has
        ]
        return parameters
    }
}
