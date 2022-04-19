//
//  ExceptionHandler.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation
import SwiftUI

final class ExceptionHandlerHelper {
    
    /// Handle error by type of backend message.
    ///
    /// For this test we simply send a generic message.
    /// - Parameters:
    ///   - statusCode: error code
    /// - Returns: Error to show to user
    func manageError(_ statusCode: Int) -> String {
        
        switch statusCode {
        case 404:
            return "An error occurred while accessing the data, try again later"
        default:
            return "An error occurred, try again later"
        }
    }
}
