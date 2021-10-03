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
    let router : HomeRouter
    
    let limit = 20
    var offset = 0
    var loadMore = false
    private(set) var characters : [Character] = []
    
    private(set) var charactersDataResponse : ResponseCharactersData? {
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
    
    init(router: HomeRouter, characterService: CharacterServiceProtocol) {
        self.characterService = characterService
        self.router = router
        getCharacters()
    }
    
    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    func showCharacterDetail(character: Character) {
        router.showCharacterDetail(character: character, characterService: self.characterService)
    }
    
    func showSimpleAlert() {
        router.showSimpleAlertAccept(alertTitle: NSLocalizedString(errorMessaje ?? "", comment: ""), alertMessage: "")
    }
    
    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    func getCharacters() {
        characterService.requestGetCharacter(limit: limit, offset: offset, withSuccess: { (result) in
            self.charactersDataResponse = result
            self.characters += result.all ?? []
            
            self.loadMore = self.characterService.isMoreDataToLoad(offset: self.charactersDataResponse?.offset ?? 0, total: self.charactersDataResponse?.total ?? 0, limit: self.limit)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
    }
    
    func paginate() {
        offset += limit
        getCharacters()
    }
    
}

