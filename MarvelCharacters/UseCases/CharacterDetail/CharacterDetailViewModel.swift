//
//  CharacterDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

final class CharacterDetailViewModel {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    let characterService : CharacterServiceProtocol
    let limit = 20
    var offset = 0
    private var loadMore = false
    private(set) var character : Character?
    private(set) var comics : [Comic] = []
    
    private(set) var responseComicsData : ResponseComicsData? {
        didSet {
            self.bindCharacterDetailViewModelToController()
        }
    }
    
    private(set) var errorMessaje : String? {
        didSet {
            self.binderrorMessajeViewModelToController()
        }
    }
    
    var bindCharacterDetailViewModelToController : (() -> ()) = {}
    var binderrorMessajeViewModelToController : (() -> ()) = {}
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    init(character: Character, characterService: CharacterServiceProtocol) {
        self.character = character
        self.characterService = characterService
        getComics()
    }

    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    func getComics(){
        characterService.requestGetComicsByCharacter(characterId: character?.id ?? 0,limit: limit, offset: offset, withSuccess: { (result) in
            
            self.comics += result.all
            self.responseComicsData = result

            if (self.responseComicsData?.count ?? 0) == (self.responseComicsData?.limit ?? 0) {
                self.loadMore = true
            }
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
        
    }

    func paginate() {
        if loadMore {
            offset += limit
            getComics()
        }
    }
    
}
