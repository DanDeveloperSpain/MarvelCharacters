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


//Singleton
final class MarvelApiService {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    var AFManager : Session
    let URLEncoding : URLEncoding
    var headers : HTTPHeaders
    
    //In a real project not set the url to fire, I would create a different Scheme (Develop, PreProd, PROD, ...), I would specify the different urls in the BuildSeting and get it automatically according to the compilation.
    let BASE_URL = "https://gateway.marvel.com:443" // Bundle.main.infoDictionary!["ServerURL"] as! String
    
    private var privateKey: String {
      get {
        guard let value = ProcessInfo.processInfo.environment["PRIVATE_KEY"] else {
          fatalError("Couldn't find key 'PRIVATE_KEY' in 'Marvel-Info.plist'.")
        }
        return value
      }
    }
    
    private var publicKey: String {
      get {
        guard let value = ProcessInfo.processInfo.environment["PUBLIC_KEY"] else {
          fatalError("Couldn't find key 'PUBLIC_KEY' in 'Marvel-Info.plist'.")
        }
        return value
      }
    }
    
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "network")
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    private init() {
        headers =  ["Accept": "*/*"]
        URLEncoding = Alamofire.URLEncoding(destination: .queryString)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 50
        configuration.timeoutIntervalForResource = 50
        AFManager = Session(configuration: configuration)
    }
    
    static let sharedInstance = MarvelApiService()
    
    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    
    private func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data()).map { String(format: "%02hhx", $0) }.joined()
    }
    
    //------------------------------------------------
    // MARK: - Helpers
    //------------------------------------------------
    
    func getParameters() -> [String: Any] {
        
        let currentTimeStamp = Int(Date().timeIntervalSince1970)

        let has = md5Hash("\(currentTimeStamp)" + privateKey + publicKey)
        
        let parameters: [String: Any] = [
            "apikey" : publicKey,
            "ts" : currentTimeStamp as Any,
            "hash" :  has as Any
        ]
        
        return parameters
        
    }
    
}
