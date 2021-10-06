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
    case comics(Int)
    case series(Int)
    
    /// Manage the URLs of the endpoint to attack.
    /// - Returns: String with the specific URL of the API endpoint
    func getURL() -> String {
        switch self {
        case .characters:
            return Constants.Paths.character
        case .comics(let characterId):
            return Constants.Paths.comics(characterId: characterId)
        case .series(let characterId):
            return Constants.Paths.series(characterId: characterId)
        }
    }
    
}

//------------------------------------------------
// MARK: - CharacterServiceProtocol
//------------------------------------------------

protocol CharacterServiceProtocol {
    
    func requestGetCharacter(limit: Int, offset: Int, withSuccess: @escaping (ResponseCharactersData) -> Void, withFailure:@escaping (_ error: String) -> Void)
    
    func requestGetComicsByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseComicsData) -> Void, withFailure:@escaping (_ error: String) -> Void)
    
    func requestGetSeriesByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseSeriesData) -> Void, withFailure:@escaping (_ error: String) -> Void)
    
    func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool
    
    func numLastItemToShow(offset: Int, all: Int) -> Int
    
}

//------------------------------------------------
// MARK: - CharacterService
//------------------------------------------------

class CharacterService : CharacterServiceProtocol {
    
    let marvelApiService = MarvelApiService.sharedInstance
    let exceptionHandler = ExceptionHandlerHelper()
    
    /// Request characters data to Api.
    /// - Parameters:
    ///   - limit: limit of the results.
    ///   - offset: exclude results.
    ///   - withSuccess: result of data back
    ///   - withFailure: error of request
    func requestGetCharacter(limit: Int, offset: Int, withSuccess: @escaping (ResponseCharactersData) -> Void, withFailure:@escaping (_ error: String) -> Void) {

        var parameters = marvelApiService.getParameters()
        
        parameters["limit"] = limit as Any
        parameters["offset"] = offset as Any
        
        let url = Constants.Paths.baseUrl + CharacterServiceEndpoint.characters.getURL()
        
        marvelApiService.AFManager.request(url, method: .get, parameters: parameters, encoding: marvelApiService.URLEncoding, headers: marvelApiService.headers).validate().responseDecodable(of: ResponseCharacters.self) { response in
            
            switch response.result {
                
            case let .success(responseCharacters):
                
                withSuccess(responseCharacters.data)
                
            case .failure:
                
                withFailure(self.failureResponse(statusCode:  response.response?.statusCode ?? 0, errorDescription: "\(String(describing: response.error?.errorDescription))"))
            }
        }
        
    }
    
    func requestGetComicsByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseComicsData) -> Void, withFailure:@escaping (_ error: String) -> Void) {
        
        var parameters = marvelApiService.getParameters()
        
        parameters["limit"] = limit as Any
        parameters["offset"] = offset as Any
        
        let url = Constants.Paths.baseUrl + CharacterServiceEndpoint.comics(characterId).getURL()
        
        marvelApiService.AFManager.request(url, method: .get, parameters: parameters, encoding: marvelApiService.URLEncoding, headers: marvelApiService.headers).validate().responseDecodable(of: ResponseComics.self) { response in
            
            switch response.result {
                
            case let .success(responseCharacters):
                
                withSuccess(responseCharacters.data)
                
            case .failure:
                
                withFailure(self.failureResponse(statusCode:  response.response?.statusCode ?? 0, errorDescription: "\(String(describing: response.error?.errorDescription))"))
            }
        }
    }

    func requestGetSeriesByCharacter(characterId: Int, limit: Int, offset: Int, withSuccess: @escaping (ResponseSeriesData) -> Void, withFailure:@escaping (_ error: String) -> Void) {
        
        var parameters = marvelApiService.getParameters()
        
        parameters["limit"] = limit as Any
        parameters["offset"] = offset as Any
        
        let url = Constants.Paths.baseUrl + CharacterServiceEndpoint.series(characterId).getURL()
        
        marvelApiService.AFManager.request(url, method: .get, parameters: parameters, encoding: marvelApiService.URLEncoding, headers: marvelApiService.headers).validate().responseDecodable(of: ResponseSeries.self) { response in
            
            switch response.result {
                
            case let .success(responseSeries):
                
                withSuccess(responseSeries.data)
                
            case .failure:
                
                withFailure(self.failureResponse(statusCode:  response.response?.statusCode ?? 0, errorDescription: "\(String(describing: response.error?.errorDescription))"))
            }
        }
    }
    
    //------------------------------------------------
    // MARK: - Helpers
    //------------------------------------------------
    
    /// Check if there is more data to request the Api.
    /// - Parameters:
    ///   - offset: exclude results.
    ///   - total: total results.
    ///   - limit: limit of the results.
    /// - Returns: True if there is more data to request.
    func isMoreDataToLoad(offset: Int, total: Int, limit: Int) -> Bool {
        if offset == 0 {
            return limit <= total ? true : false
        } else {
            return offset <= total ? true : false
        }
    }
    
    /// Helper to know the last item shown and to know if it is the last one to make the next request.
    /// - Parameters:
    ///   - offset: exclude results.
    ///   - all: number of current results getted.
    /// - Returns: Number of the current item shown.
    func numLastItemToShow(offset: Int, all: Int) -> Int {
        return offset + all - 1
    }
    
    /// Helper to show he error states returned by the Api by console. It also calls the error handler to get the error to show to user.
    /// - Parameters:
    ///   - statusCode: error code.
    ///   - errorDescription: error description.
    /// - Returns: Error to show to user
    private func failureResponse(statusCode: Int, errorDescription: String) -> String{
        os_log("statusCode = %@", log: self.marvelApiService.log, "\(String(describing: statusCode))")
        os_log("errorDescription = %@", log: self.marvelApiService.log, "\(String(describing: errorDescription))")
        
        return self.exceptionHandler.getErrorDescriptionToUser(errorDescription, statusCode)
        
    }
    
}
