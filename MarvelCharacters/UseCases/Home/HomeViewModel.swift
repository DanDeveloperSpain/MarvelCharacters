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
    private var loadMore = false
    private(set) var characters : [Character] = []

    
    private(set) var responseCharactersData : ResponseCharactersData? {
        didSet {
            self.bindCharactersViewModelToController()
        }
    }
    
    private(set) var errorMessaje : String? {
        didSet {
            self.binderrorMessajeViewModelToController()
        }
    }
    
    var bindCharactersViewModelToController : (() -> ()) = {}
    var binderrorMessajeViewModelToController : (() -> ()) = {}
    
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
    
    func getCharacters(){
        characterService.requestGetCharacter(limit: limit, offset: offset, withSuccess: { (result) in
            self.responseCharactersData = result
            self.characters += result.all
            
            if (self.responseCharactersData?.count ?? 0) == (self.responseCharactersData?.limit ?? 0) {
                self.loadMore = true
            }
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
    }
    
    func paginate() {
        if loadMore {
            offset += limit
            getCharacters()
        }
    }
    
}

