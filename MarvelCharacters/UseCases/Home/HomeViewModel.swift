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
    
    var bindCharactersViewModelToController : (() -> ()) = {}
    
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
        characterService.requestGetCharacter(url: "/v1/public/characters", limit: limit, offset: offset, withSuccess: { (result) in
            self.responseCharactersData = result
            self.characters += result.all
            
            if (self.responseCharactersData?.count ?? 0) == (self.responseCharactersData?.limit ?? 0) {
                self.loadMore = true
            }
        }, withFailure: { (error, _) in
            print(error)
        })
    }
    
    func paginate() {
        if loadMore {
            offset += limit
            getCharacters()
        }
    }
    
}

