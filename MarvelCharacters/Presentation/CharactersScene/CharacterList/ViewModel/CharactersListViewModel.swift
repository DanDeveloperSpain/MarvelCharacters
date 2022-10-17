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
        return PaginationHelper.numLastItemToShow(offset: offset)
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
    private let appConfiguration: AppConfiguration

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(coordinatorDelegate: CharactersListViewModelCoordinatorDelegate, fetchCharactersUseCase: FetchCharactersUseCaseProtocol, appConfiguration: AppConfiguration) {
        self.coordinatorDelegate = coordinatorDelegate
        self.fetchCharactersUseCase = fetchCharactersUseCase
        self.appConfiguration = appConfiguration
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

    func start() {
        if appConfiguration.checkApiKeys() {
            self.fetchCharactersLaunchesList()
        } else {
            self.tryAgainButtonisHidden.accept(false)
            self.errorMessage.onNext("There isn`t ApiKey data. Please enter your public and private key.")
        }
    }

    func checkRequestNewDataByIndex(index: Int) {
        if index == numLastCharacterToShow && loadMore {
            fetchCharactersLaunchesList()
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

        offset += limit

        self.loadMore = PaginationHelper.isMoreDataToLoad(offset: offset, total: self.responseCharacters?.total ?? 0)

    }

    private func setupCharacters(characters: [Character]) {
        let uiModels = characters.map({ CharacterCell.UIModel(characterName: $0.name, characterImageURL: $0.imageUrl)
        })

        cellUIModels.onNext(uiModels)
    }

}
