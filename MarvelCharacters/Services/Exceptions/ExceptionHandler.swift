//
//  ExceptionHandler.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

final class ExceptionHandlerHelper {
    
    /// Handle error by type of backend message.
    ///
    /// For this test we simply send a generic message.
    /// - Parameters:
    ///   - errorDescription: error description
    ///   - statusCode: error code
    /// - Returns: Error to show to user
    func getErrorDescriptionToUser(_ errorDescription: String, _ statusCode: Int) -> String {
        
        /// Example
        if statusCode == 401 {
            /// unautorized() -> log out and redirect to login
        }
        return "An error occurred, try again later"
    }
}
