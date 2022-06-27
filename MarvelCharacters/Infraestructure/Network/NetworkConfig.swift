//
//  NetworkConfig.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 17/6/22.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: String { get }
    var baseQueryItems: [String: String]? { get }
}

public class ApiDataNetworkConfig: NetworkConfigurable {
    public var baseURL: String
    public var baseQueryItems: [String: String]?

    public init(baseURL: String, publicKey: String, privateKey: String) {
        self.baseURL = baseURL
        self.baseQueryItems = setBaseParameters(publicKey: publicKey, privateKey: privateKey)
    }

    /// Helper to build the base parameters for the Api.
    /// - Returns: Array with apikey, ts and hash.
    func setBaseParameters(publicKey: String, privateKey: String) -> [String: String] {
        let currentTimeStamp = Int(Date().timeIntervalSince1970)

        let has = Encryption.md5Hash("\(currentTimeStamp)" + privateKey + publicKey)

        let parameters: [String: String] = [
            "apikey" : publicKey,
            "ts" : String(currentTimeStamp),
            "hash" :  has
        ]
        return parameters
    }
}
