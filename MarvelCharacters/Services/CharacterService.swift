//
//  CharacterService.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation
import os.log

//------------------------------------------------
// MARK: - CharacterServiceProtocol
//------------------------------------------------

protocol CharacterServiceProtocol {
    
    func requestGetCharacter(url: String, limit: Int, offset: Int, withSuccess: @escaping (Characters) -> Void, withFailure:@escaping (_ error: String, _ errorCode: Int) -> Void)
    
}

//------------------------------------------------
// MARK: - CharacterService
//------------------------------------------------

class CharacterService : CharacterServiceProtocol {
    
    let marvelApiService = MarvelApiService.sharedInstance
    
    func requestGetCharacter(url: String, limit: Int, offset: Int, withSuccess: @escaping (Characters) -> Void, withFailure:@escaping (_ error: String, _ errorCode: Int) -> Void) {
  
        var parameters = marvelApiService.getParameters()
        
        parameters["limit"] = limit as Any
        parameters["offset"] = offset as Any
        
        
        marvelApiService.AFManager.request(marvelApiService.BASE_URL + url, method: .get, parameters: parameters, encoding: marvelApiService.URLEncoding, headers: marvelApiService.headers).validate().responseDecodable(of: ResponseCharacters.self) { response in
            
            os_log("url = %@", log: self.marvelApiService.log, "\(String(describing: response.response?.url))")
            os_log("response = %@", log: self.marvelApiService.log, "\(String(describing: response.response?.statusCode))")
            
            switch response.result {
                
            case let .success(responseCharacters):
                
                withSuccess(responseCharacters.data)
                
            case .failure:
                
                if let statusCode = response.response?.statusCode {
                    
                    withFailure(response.error!.errorDescription ?? "", statusCode)
                    
                    if statusCode == 401 {
                        //unautorized() -> log out and redirect to login
                    }
                }
            }
        }
        
    }
    
}
