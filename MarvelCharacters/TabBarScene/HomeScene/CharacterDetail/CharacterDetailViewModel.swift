//
//  CharacterDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import SwiftUI

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol CharacterDetailViewModelCoordinatorDelegate: AnyObject {

}

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------
protocol CharacterDetailViewModelViewDelegate: BaseControllerViewModelProtocol {
    func showError()
    func loadComics()
    func loadSeries()
}

final class CharacterDetailViewModel: BaseViewModel {

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate?

    /// Set the view of the model.
    private weak var viewDelegate: CharacterDetailViewModelViewDelegate? {
        return self.baseView as? CharacterDetailViewModelViewDelegate
    }

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return character?.name ?? ""
    }

    let characterService: CharacterServiceProtocol

    let limitComic = 20
    let limitSerie = 20
    var offsetComic = 0
    var offsetSerie = 0
    var loadMoreComic = false
    var loadMoreSerie = false

    private(set) var character: Character?

    /// Comics datasource.
    private(set) var comics: [Comic] = []

    /// Series datasource.
    private(set) var series: [Serie] = []

    let numberOfSections = 2

    /// Indicate the last comic that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastComicToShow: Int {
        return characterService.numLastItemToShow(offset: comicsDataResponse?.offset ?? 0, all: comicsDataResponse?.all?.count ?? 0)
    }

    /// Indicate the last serie that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastSerieToShow: Int {
        return characterService.numLastItemToShow(offset: seriesDataResponse?.offset ?? 0, all: seriesDataResponse?.all?.count ?? 0)
    }

    /// Comic binding to notify the view.
    private(set) var comicsDataResponse: ResponseComicsData? {
        didSet {
            self.viewDelegate?.loadComics()
        }
    }

    /// Serie binding to notify the view.
    private(set) var seriesDataResponse: ResponseSeriesData? {
        didSet {
            self.viewDelegate?.loadSeries()
        }
    }

    private(set) var errorMessaje: String? {
        didSet {
            self.viewDelegate?.showError()
        }
    }

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new CharacterDetailViewModel
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate
    ///   - character: Character to show
    ///   - characterService: Api call service.
    init(coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate, character: Character, characterService: CharacterServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.character = character
        self.characterService = characterService
    }

    deinit {
        print("CharacterDetailViewModel deinit")
    }

    /// First call of viewmodel lifecycle.
    override func start() {
        Task {
            try await getComics()
            try await getSeries()
        }
        print("___ start CharacterDetailViewModel")
    }

    // ---------------------------------
    // MARK: - Public methods
    // ---------------------------------

    func numberOfSectionsInCollectionView() -> Int {
          return numberOfSections
        }

    func numberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return comics.count
        case 1:
            return series.count
        default:
            return 0
        }
    }

    func titleAtIndex(index: Int, type: MediaType) -> String {
        return type == .comic ? comics[index].title ?? "" : series[index].title ?? ""
    }

    func yearAtIndex(index: Int, type: MediaType) -> String {
        return type == .comic ? comics[index].year ?? "" : series[index].startYear.map(String.init) ?? ""
    }

    func urlImgeAtIndex(index: Int, type: MediaType) -> String {
        return type == .comic ? "\(comics[index].thumbnail?.path ?? "").\(comics[index].thumbnail?.typeExtension ?? "")" : "\(series[index].thumbnail?.path ?? "").\(series[index].thumbnail?.typeExtension ?? "")"
    }

    /// Next request if there are more comic or serie, when we reach the end of the list.
    func paginate(mediaType: MediaType) {

        switch mediaType {
        case .comic:
            offsetComic += limitComic
            Task {
                try await getComics()
            }
        case .serie:
            offsetSerie += limitSerie
            Task {
                try await getSeries()
            }
        }
    }

    // ------------------------------------------------
    // MARK: - Backend
    // ------------------------------------------------

    /// Request comics data to CharacterService (API).
    func getComics() async throws {
        do {
            let resultComics = try await characterService.requestGetComicsByCharacter(characterId: character?.id ?? 0, limit: limitComic, offset: offsetComic)
            self.comics += resultComics.all ?? []
            self.comicsDataResponse = resultComics

            self.loadMoreComic = self.characterService.isMoreDataToLoad(offset: self.comicsDataResponse?.offset ?? 0, total: self.comicsDataResponse?.total ?? 0, limit: self.limitComic)

        } catch let error {
            self.errorMessaje = self.characterService.getErrorDescriptionToUser(statusCode: error.asAFError?.responseCode ?? 0)

        }
    }

    /// Request series data to CharacterService (API).
    func getSeries() async throws {
        do {
            let resultSeries = try await characterService.requestGetSeriesByCharacter(characterId: character?.id ?? 0, limit: limitSerie, offset: offsetSerie)
            self.series += resultSeries.all ?? []
            self.seriesDataResponse = resultSeries

            self.loadMoreSerie = self.characterService.isMoreDataToLoad(offset: self.seriesDataResponse?.offset ?? 0, total: self.seriesDataResponse?.total ?? 0, limit: self.limitSerie)

        } catch let error {
            self.errorMessaje = self.characterService.getErrorDescriptionToUser(statusCode: error.asAFError?.responseCode ?? 0)
        }

    }

}
