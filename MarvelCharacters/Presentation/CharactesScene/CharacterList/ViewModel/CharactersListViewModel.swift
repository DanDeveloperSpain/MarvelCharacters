//
//  CharactersListViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import Foundation
import RxSwift
import RxRelay

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

final class CharactersListViewModel { //: BaseViewModel {

    // MARK: - Variables
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    let cellUIModels: PublishSubject<[CharacterCell.UIModel]> = PublishSubject()
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let tryAgainButtonisHidden: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let errorMessage: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    var responseCharactersData: ResponseCharactersData?

    // MARK: - Init
    init(coordinatorDelegate: CharactersListViewModelCoordinatorDelegate, fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    /// Fetches the list of songs either from the internet or local storage via use case
    func fetchCharactersLaunchesList() {
        isLoading.accept(true)
        tryAgainButtonisHidden.accept(true)
        fetchCharactersUseCase.execute(limit: limit, offset: offset)
            .subscribe {[weak self] event in
                self?.isLoading.accept(false)
                guard let self = self else { return }
                switch event {
                case .next(let responseCharacterData):
                    self.handleResponseCharactersDataData(data: responseCharacterData)
                case .error(let error):
                    self.tryAgainButtonisHidden.accept(false)
                    let nsError = error as NSError
                    self.errorMessage.onNext(nsError.domain)
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }

    private func setupData(characters: [Character]) {
        var uiModels = [CharacterCell.UIModel]()
        characters.forEach { character in
            uiModels.append(CharacterCell.UIModel(characterName: character.name, characterImageURL: "\(character.thumbnail?.path ?? "").\(character.thumbnail?.typeExtension ?? "")"))
        }
        cellUIModels.onNext(uiModels)
    }

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: CharactersListViewModelCoordinatorDelegate?

    /// Set the view of the model.
//    private weak var viewDelegate: CharactersListViewModelViewDelegate? {
//        return self.baseView as? CharactersListViewModelViewDelegate
//    }

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return NSLocalizedString("Marvel characters", comment: "")
    }

    // let characterService: CharacterServiceProtocol

    let limit = 20
    var offset = 0
    var loadMore = false

    /// Character datasource.
    private(set) var characters: [Character] = []

    /// Indicate the last character that will be shown in the list, to know when to make the next request to obtain more characters.
    private var numLastCharacterToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseCharactersData?.offset ?? 0, all: responseCharactersData?.all?.count ?? 0)
    }

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new CharactersListviewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate.
    ///   - characterService: Api call service.
//    init(coordinatorDelegate: CharactersListViewModelCoordinatorDelegate, characterService: CharacterServiceProtocol) {
//        self.coordinatorDelegate = coordinatorDelegate
//        self.characterService = characterService
//    }

    /// First call of viewmodel lifecycle.
//    override func start() {
//        Task {
//            checkApiKeys() ? try await getCharacters() : setErrorApiKey()
//        }
//    }

    // ---------------------------------
    // MARK: - Public methods
    // ---------------------------------

    func checkRequestNewDataByIndex(index: Int) {
        if index == numLastCharacterToShow && loadMore {
            paginate()
        }
    }

//    func numberOfItemsInSection(section: Int) -> Int {
//        return characters.count
//    }
//
//    func characterNameAtIndex(index: Int) -> String {
//        return characters[index].name ?? ""
//    }
//
//    func characterUrlImgeAtIndex(index: Int) -> String {
//        return "\(characters[index].thumbnail?.path ?? "").\(characters[index].thumbnail?.typeExtension ?? "")"
//    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func cellAtIndexTapped(index: Int) {
        coordinatorDelegate?.goToCharacterDetail(character: characters[index])
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func handleResponseCharactersDataData(data: ResponseCharactersData) {
        self.responseCharactersData = data
        self.characters += data.all ?? []
        self.setupData(characters: self.characters)

        self.loadMore = PaginationHelper.isMoreDataToLoad(offset: self.responseCharactersData?.offset ?? 0, total: self.responseCharactersData?.total ?? 0, limit: self.limit)
    }

    private func paginate() {
        offset += limit
        fetchCharactersLaunchesList()
    }

    /// Check if Api Keys are added
    private func checkApiKeys() -> Bool {
        AppConfiguration().publicKey.isEmpty || AppConfiguration().privateKey.isEmpty ? false : true
    }

//    private func setErrorApiKey() {
//        self.errorMessaje = ("There isn`t ApiKey data", "Please enter your public and private key in Schemes -> Edit Scheme -> Environment Variables")
//    }

    // ------------------------------------------------
    // MARK: - Backend
    // ------------------------------------------------

    /// Request data to CharacterService (API).

}
