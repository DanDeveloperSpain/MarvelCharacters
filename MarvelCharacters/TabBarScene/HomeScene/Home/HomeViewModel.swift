//
//  HomeViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import UIKit

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol HomeViewModelCoordinatorDelegate: AnyObject { // ---> HomeCoordinator
    func goToCharacterDetail(character: Character)
}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------

protocol HomeViewModelViewDelegate: BaseControllerViewModelProtocol { // ---> HomeViewController
    func showError() -> Void
    func loadCharacters() -> Void
}

final class HomeViewModel: BaseViewModel {
    
    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    /// Set the view of the model.
    private weak var viewDelegate: HomeViewModelViewDelegate? {
        return self.baseView as? HomeViewModelViewDelegate
    }
    
    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------
    
    var title: String {
        return NSLocalizedString("Marvel characters", comment: "")
    }
    
    let characterService : CharacterServiceProtocol
    
    let limit = 20
    var offset = 0
    var loadMore = false
    
    /// Character datasource.
    private(set) var characters : [Character] = []
    
    /// Indicate the last character that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastCharacterToShow: Int {
        return characterService.numLastItemToShow(offset: charactersDataResponse?.offset ?? 0, all: charactersDataResponse?.all?.count ?? 0)
    }
    
    /// Character binding to notify the view.
    private(set) var charactersDataResponse : ResponseCharactersData? {
        didSet {
            self.viewDelegate?.loadCharacters()
        }
    }
    
    /// Error binding to report to view.
    private(set) var errorMessaje : (String, String)? {
        didSet {
            self.viewDelegate?.showError()
        }
    }
    
    //------------------------------------------------
    // MARK: - ViewModel
    //------------------------------------------------
    
    /// Create a new HomeviewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate
    ///   - characterService: Api call service.
    init(coordinatorDelegate: HomeViewModelCoordinatorDelegate, characterService: CharacterServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.characterService = characterService
    }
    
    /// First call of viewmodel lifecycle.
    override func start() {
        checkApiKeys() ? getCharacters() : setErrorApiKey()
        print("___ start HomeViewModel")
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------
    func showCharacterDetail(character: Character) {
        coordinatorDelegate?.goToCharacterDetail(character: character)
    }
    
    /// Check if Api Keys are added
    func checkApiKeys() -> Bool {
        Constants.ApiKeys.publicKey.isEmpty || Constants.ApiKeys.privateKey.isEmpty ? false : true
    }
    
    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    
    private func setErrorApiKey() {
        self.errorMessaje = ("There isn`t ApiKey data", "Please enter your public and private key in Schemes -> Edit Scheme -> Environment Variables")
    }
    
    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    /// Request data to CharacterService (API).
    func getCharacters() {
        characterService.requestGetCharacter(limit: limit, offset: offset, withSuccess: { (result) in
            self.charactersDataResponse = result
            self.characters += result.all ?? []
            
            self.loadMore = self.characterService.isMoreDataToLoad(offset: self.charactersDataResponse?.offset ?? 0, total: self.charactersDataResponse?.total ?? 0, limit: self.limit)
            
        }, withFailure: { (error) in
            self.errorMessaje = (error, "")
        })
    }
    
    /// Next request if there are more characters, when we reach the end of the list.
    func paginate() {
        offset += limit
        getCharacters()
    }
    
}
