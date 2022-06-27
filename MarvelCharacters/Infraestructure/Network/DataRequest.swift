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

    var path: String { get }
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
