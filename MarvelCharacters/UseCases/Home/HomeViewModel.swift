//
//  HomeViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation

final class HomeViewModel {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    let characterService : CharacterServiceProtocol
    
    let limit = 20
    var offset = 0
    var loadMore = false
    private(set) var characters : [Character] = []
    
    private(set) var responseCharactersData : ResponseCharactersData? {
        didSet {
            self.bindingCharacter()
        }
    }
    
    private(set) var errorMessaje : String? {
        didSet {
            self.bindingError()
        }
    }
    
    var bindingCharacter : (() -> ()) = {}
    var bindingError : (() -> ()) = {}
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
        getCharacters()
    }
    
    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    func getCharacters() {
        characterService.requestGetCharacter(limit: limit, offset: offset, withSuccess: { (result) in
            self.responseCharactersData = result
            self.characters += result.all ?? []
            
            self.loadMore = self.characterService.isMoreDataToLoad(offset: self.responseCharactersData?.offset ?? 0, total: self.responseCharactersData?.total ?? 0, limit: self.limit)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
    }
    
    func paginate() {
        offset += limit
        getCharacters()
    }
    
}

