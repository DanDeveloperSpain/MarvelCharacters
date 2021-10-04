//
//  HomeViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation

final class HomeViewModel: BaseViewModel {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    private weak var view: HomeViewControllerProtocol? {
        return self.baseView as? HomeViewControllerProtocol
    }
    
    private var router: HomeRouter? {
        return self._router as? HomeRouter
    }
    
    var title: String {
        return NSLocalizedString("Marvel characters", comment: "")
    }
    
    let characterService : CharacterServiceProtocol
    
    let limit = 20
    var offset = 0
    var loadMore = false
    private(set) var characters : [Character] = []
    
    private(set) var charactersDataResponse : ResponseCharactersData? {
        didSet {
            self.view?.loadCharacters()
        }
    }
    
    private(set) var errorMessaje : (String, String)? {
        didSet {
            self.view?.loadError()
        }
    }
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    init(router: BaseRouter, characterService: CharacterServiceProtocol) {
        self.characterService = characterService
        super.init(router: router)
    }
    
    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------
    
    override func loadView() {
        checkApiKeys()
    }

    func showCharacterDetail(character: Character) {
        router?.showCharacterDetail(character: character, characterService: self.characterService)
    }
    
    func numLastCharacterToShow() -> Int {
        return (charactersDataResponse?.offset ?? 0) + (charactersDataResponse?.count ?? 0) - 1
    }
    
    func checkApiKeys() {
        if Constants.ApiKeys.publicKey.isEmpty || Constants.ApiKeys.privateKey.isEmpty {
            self.errorMessaje = ("There isn`t ApiKey data", "Please enter your public and private key in Schemes -> Edit Scheme -> Environment Variables")
            //self.errorMessaje.append("Please enter public and private key")
        } else {
            getCharacters()
        }
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
            self.errorMessaje = (error, "")
        })
    }
    
    func paginate() {
        offset += limit
        getCharacters()
    }
    
}

