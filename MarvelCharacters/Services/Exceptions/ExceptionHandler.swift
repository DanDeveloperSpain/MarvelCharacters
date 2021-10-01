//
//  ExceptionHandler.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

final class ExceptionHandlerHelper {
    
    func getErrorDescriptionToUser(_ errorDescription: String, _ statusCode: Int) -> String {
        
        if statusCode == 401 {
            //unautorized() -> log out and redirect to login
        }
        
        // Handle error by type of backend message, for this test we simply send a generic message.
        
        return "An error occurred, try again later"
    }
}
