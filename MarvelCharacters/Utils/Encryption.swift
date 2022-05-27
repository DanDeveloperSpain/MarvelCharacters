//
//  Encryption.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 27/5/22.
//

import Foundation
import CryptoKit

class Encryption {

    /// Function to has a String in md5.
    /// - Parameter source: in this case a string format for: ts, privateKey and publicKey.
    /// - Returns: Hashed String.
    static func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data()).map { String(format: "%02hhx", $0) }.joined()
    }

}
