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
    
    private(set) var charactersData : Characters! {
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
        characterService.requestGetCharacter(url: "/v1/public/characters", limit: 20, offset: 0, withSuccess: { (result) in
            print(result)
            self.charactersData = result
        }, withFailure: { (error, _) in
            print(error)
        })
    }
    
}

