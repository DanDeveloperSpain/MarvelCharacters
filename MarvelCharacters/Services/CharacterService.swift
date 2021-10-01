//
//  CharacterService.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation
import os.log

//------------------------------------------------
// MARK: - CharacterServiceEndpoint
//------------------------------------------------
enum CharacterServiceEndpoint {
    
    case characters
    case comics(String)
    
    func getURL() -> String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comics(let characterId):
            return "/v1/public/characters/\(characterId)/comics"
        }
    }
    
}

//------------------------------------------------
// MARK: - CharacterServiceProtocol
//------------------------------------------------

protocol CharacterServiceProtocol {
    
    func requestGetCharacter(limit: Int, offset: Int, withSuccess: @escaping (ResponseCharactersData) -> Void, withFailure:@escaping (_ error: String) -> Void)
    
}

//------------------------------------------------
// MARK: - CharacterService
//------------------------------------------------

class CharacterService : CharacterServiceProtocol {
    
    let marvelApiService = MarvelApiService.sharedInstance
    let exceptionHandler = ExceptionHandlerHelper()
    
    func requestGetCharacter(limit: Int, offset: Int, withSuccess: @escaping (ResponseCharactersData) -> Void, withFailure:@escaping (_ error: String) -> Void) {

        var parameters = marvelApiService.getParameters()
        
        parameters["limit"] = limit as Any
        parameters["offset"] = offset as Any
        
        let url = marvelApiService.BASE_URL + CharacterServiceEndpoint.characters.getURL()
        
        marvelApiService.AFManager.request(url, method: .get, parameters: parameters, encoding: marvelApiService.URLEncoding, headers: marvelApiService.headers).validate().responseDecodable(of: ResponseCharacters.self) { response in
            
            os_log("url = %@", log: self.marvelApiService.log, "\(String(describing: response.response?.url))")
            os_log("response = %@", log: self.marvelApiService.log, "\(String(describing: response.response?.statusCode))")
            
            switch response.result {
                
            case let .success(responseCharacters):
                
                withSuccess(responseCharacters.data)
                
            case .failure:
                
                os_log("statusCode = %@", log: self.marvelApiService.log, "\(String(describing: response.response?.statusCode))")
                os_log("errorDescription = %@", log: self.marvelApiService.log, "\(String(describing: response.error!.errorDescription))")

                if let statusCode = response.response?.statusCode {
                    
                    let error = self.exceptionHandler.getErrorDescriptionToUser(response.error!.errorDescription ?? "", statusCode)
                    
                    withFailure(error)

                }
            }
        }
        
    }
    
}
