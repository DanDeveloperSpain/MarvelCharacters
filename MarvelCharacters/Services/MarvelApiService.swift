//
//  MarvelApiService.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation
import Alamofire
import os.log
import CryptoKit

/// Singleton.
final class MarvelApiService {
    
    var AFManager : Session
    let URLEncoding : URLEncoding
    var headers : HTTPHeaders
    
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "network")
    
    /// Initialize the singleton with the headers and Alamofire session to make API requests.
    private init() {
        headers =  ["Accept": "*/*"]
        URLEncoding = Alamofire.URLEncoding(destination: .queryString)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 50
        configuration.timeoutIntervalForResource = 50
        AFManager = Session(configuration: configuration)
    }
    
    /// Shared instance to access the singleton.
    static let sharedInstance = MarvelApiService()
    
    /// Function to has a String in md5.
    /// - Parameter source: in this case a string format for: ts, privateKey and publicKey.
    /// - Returns: Hashed String.
    private func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data()).map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Helper to build the base parameters for the Api.
    /// - Returns: Array with apikey, ts and hash.
    func getParameters() -> [String: Any] {
        let currentTimeStamp = Int(Date().timeIntervalSince1970)

        let has = md5Hash("\(currentTimeStamp)" + Constants.ApiKeys.privateKey + Constants.ApiKeys.publicKey)
        
        let parameters: [String: Any] = [
            "apikey" : Constants.ApiKeys.publicKey,
            "ts" : currentTimeStamp as Any,
            "hash" :  has as Any
        ]
        return parameters
    }
    
}
