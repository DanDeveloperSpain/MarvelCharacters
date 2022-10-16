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

final class CharactersListViewModel {

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return NSLocalizedString("Marvel characters", comment: "")
    }

    /// Character datasource.
    private(set) var characters: [Character] = []

    /// DataResponse
    var responseCharacters: ResponseCharacters?

    /// Indicate the last character that will be shown in the list, to know when to make the next request to obtain more characters.
    private var numLastCharacterToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseCharacters?.offset ?? 0, all: responseCharacters?.characters?.count ?? 0)
    }

    let limit = 20
    var offset = 0
    var loadMore = false

    // ---------------------------------
    // MARK: - Properties RX-Bindings
    // ---------------------------------

    let cellUIModels: PublishSubject<[CharacterCell.UIModel]> = PublishSubject()
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let tryAgainButtonisHidden: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let errorMessage: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()

    // ---------------------------------
    // MARK: - Delegates & UseCases
    // ---------------------------------

    private weak var coordinatorDelegate: CharactersListViewModelCoordinatorDelegate?
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(coordinatorDelegate: CharactersListViewModelCoordinatorDelegate, fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }

    // ------------------------------------------------
    // MARK: - Fetches
    // ------------------------------------------------

    /// Fetches the list of characters from the internet or local storage via use case. (internet in this case)
    func fetchCharactersLaunchesList() {
        isLoading.accept(true)
        tryAgainButtonisHidden.accept(true)
        fetchCharactersUseCase.execute(limit: limit, offset: offset)
            .subscribe {[weak self] event in
                self?.isLoading.accept(false)
                guard let self = self else { return }
                switch event {
                case .next(let responseCharacter):
                    self.handleResponseCharacters(data: responseCharacter)
                case .error(let error):
                    self.tryAgainButtonisHidden.accept(false)
                    let nsError = error as NSError
                    self.errorMessage.onNext(nsError.domain)
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }

    // ---------------------------------
    // MARK: - Public methods
    // ---------------------------------

    func checkRequestNewDataByIndex(index: Int) {
        if index == numLastCharacterToShow && loadMore {
            paginate()
        }
    }

    // ---------------------------------
    // MARK: - Events
    // ---------------------------------

    func cellAtIndexTapped(index: Int) {
        coordinatorDelegate?.goToCharacterDetail(character: characters[index])
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func handleResponseCharacters(data: ResponseCharacters) {
        self.responseCharacters = data
        self.characters += data.characters ?? []
        self.setupCharacters(characters: self.characters)

        self.loadMore = PaginationHelper.isMoreDataToLoad(offset: self.responseCharacters?.offset ?? 0, total: self.responseCharacters?.total ?? 0, limit: self.limit)
    }

    private func setupCharacters(characters: [Character]) {
        let uiModels = characters.map({ CharacterCell.UIModel(characterName: $0.name, characterImageURL: $0.imageUrl)
        })

        cellUIModels.onNext(uiModels)
    }

    private func paginate() {
        offset += limit
        fetchCharactersLaunchesList()
    }

    /// Check if Api Keys are added
    private func checkApiKeys() -> Bool {
        AppConfiguration().publicKey.isEmpty || AppConfiguration().privateKey.isEmpty ? false : true
    }

}
