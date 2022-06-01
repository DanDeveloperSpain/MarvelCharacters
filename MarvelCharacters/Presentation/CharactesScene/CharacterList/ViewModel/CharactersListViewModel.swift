//
//  CharactersListViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol CharactersListViewModelCoordinatorDelegate: AnyObject { // ---> CharactersListCoordinator
    func goToCharacterDetail(character: Character)
}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------

protocol CharactersListViewModelViewDelegate: BaseControllerViewModelProtocol { // ---> CharactersListViewController
    func showError()
    func loadCharacters()
}

final class CharactersListViewModel: BaseViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: CharactersListViewModelCoordinatorDelegate?

    /// Set the view of the model.
    private weak var viewDelegate: CharactersListViewModelViewDelegate? {
        return self.baseView as? CharactersListViewModelViewDelegate
    }

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return NSLocalizedString("Marvel characters", comment: "")
    }

    let characterService: CharacterServiceProtocol

    let limit = 20
    var offset = 0
    var loadMore = false

    /// Character datasource.
    private(set) var characters: [Character] = []

    /// Indicate the last character that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastCharacterToShow: Int {
        return characterService.numLastItemToShow(offset: charactersDataResponse?.offset ?? 0, all: charactersDataResponse?.all?.count ?? 0)
    }

    /// Character binding to notify the view.
    private(set) var charactersDataResponse: ResponseCharactersData? {
        didSet {
            self.viewDelegate?.loadCharacters()
        }
    }

    /// Error binding to report to view.
    private(set) var errorMessaje: (String, String)? {
        didSet {
            self.viewDelegate?.showError()
        }
    }

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new CharactersListviewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate.
    ///   - characterService: Api call service.
    init(coordinatorDelegate: CharactersListViewModelCoordinatorDelegate, characterService: CharacterServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.characterService = characterService
    }

    /// First call of viewmodel lifecycle.
    override func start() {
        Task {
            checkApiKeys() ? try await getCharacters() : setErrorApiKey()
        }
    }

    // ---------------------------------
    // MARK: - Public methods
    // ---------------------------------

    func numberOfItemsInSection(section: Int) -> Int {
        return characters.count
    }

    func characterNameAtIndex(index: Int) -> String {
        return characters[index].name ?? ""
    }

    func characterUrlImgeAtIndex(index: Int) -> String {
        return "\(characters[index].thumbnail?.path ?? "").\(characters[index].thumbnail?.typeExtension ?? "")"
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func cellAtIndexTapped(index: Int) {
        coordinatorDelegate?.goToCharacterDetail(character: characters[index])
    }

    /// Check if Api Keys are added
    func checkApiKeys() -> Bool {
        Constants.ApiKeys.publicKey.isEmpty || Constants.ApiKeys.privateKey.isEmpty ? false : true
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func setErrorApiKey() {
        self.errorMessaje = ("There isn`t ApiKey data", "Please enter your public and private key in Schemes -> Edit Scheme -> Environment Variables")
    }

    // ------------------------------------------------
    // MARK: - Backend
    // ------------------------------------------------

    /// Request data to CharacterService (API).
    func getCharacters() async throws {
        do {
            let ressultCharacters = try await characterService.requestGetCharacter(limit: limit, offset: offset)
            self.charactersDataResponse = ressultCharacters
            self.characters += ressultCharacters.all ?? []

            self.loadMore = self.characterService.isMoreDataToLoad(offset: self.charactersDataResponse?.offset ?? 0, total: self.charactersDataResponse?.total ?? 0, limit: self.limit)

        } catch let error {
            let errorToShow = self.characterService.getErrorDescriptionToUser(statusCode: error.asAFError?.responseCode ?? 0)
            self.errorMessaje = (errorToShow, "")
        }
    }

    /// Next request if there are more characters, when we reach the end of the list.
    func paginate() {
        offset += limit
        Task {
            try await getCharacters()
        }
    }

}
