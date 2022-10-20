//
//  CharacterDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

// ---------------------------------
// MARK: - Coordinator Delegates
// ---------------------------------

protocol CharacterDetailViewModelCoordinatorDelegate: AnyObject {

}

final class CharacterDetailViewModel {

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return character?.name ?? ""
    }

    private(set) var character: Character?

    private(set) var allComics: [Comic] = []
    private(set) var filteredComics: [Comic] = []
    var responseComics: ResponseComics?

    private(set) var allSeries: [Serie] = []
    private(set) var filteredSeries: [Serie] = []
    var responseSeries: ResponseSeries?

    var yearsToFilter: PublishSubject<[Int]> = PublishSubject()
    var selectedFilteredYear: Int?

    /// Indicate the last comic that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastComicToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: offsetComic)
    }
    /// Indicate the last serie that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastSerieToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: offsetSerie)
    }

    let limitComic = 20
    let limitSerie = 20
    var offsetComic = 0
    var offsetSerie = 0
    var loadMoreComic = false
    var loadMoreSerie = false

    // ---------------------------------
    // MARK: - Properties RX-Bindings
    // ---------------------------------

    /// datasource
    let items: PublishSubject<[SectionModel<String, ComicSerieCell.UIModel>]> = PublishSubject()

    var cellComicsUIModels = [ComicSerieCell.UIModel]()
    var cellSeriesUIModels = [ComicSerieCell.UIModel]()
    let isComicsLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isSeriesLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let yearFilterTextFieldIsHidden: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let errorMessage: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()

    // ---------------------------------
    // MARK: - Delegates & UseCases
    // ---------------------------------

    private weak var coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate?
    private let fetchComicsUseCase: FetchComicsUseCaseProtocol
    private let fetchSeriesUseCase: FetchSeriesUseCaseProtocol

    // ---------------------------------
    // MARK: - Init
    // ---------------------------------

    init(coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate, fetchComicsUseCase: FetchComicsUseCaseProtocol, fetchSeriesUseCase: FetchSeriesUseCaseProtocol, character: Character) {
        self.coordinatorDelegate = coordinatorDelegate
        self.fetchComicsUseCase = fetchComicsUseCase
        self.fetchSeriesUseCase = fetchSeriesUseCase
        self.character = character
    }

    // ------------------------------------------------
    // MARK: - Fetches
    // ------------------------------------------------

    func fetchComicsLaunchesList() {
        isComicsLoading.accept(true)
        fetchComicsUseCase.execute(characterId: String(character?.id ?? 0), limit: limitComic, offset: offsetComic)
            .subscribe {[weak self] event in
                self?.isComicsLoading.accept(false)
                self?.yearFilterTextFieldIsHidden.accept(false)
                guard let self = self else { return }
                switch event {
                case .next(let responseComics):
                    self.handleResponseComics(data: responseComics)
                case .error(let error):
                    let nsError = error as NSError
                    self.errorMessage.onNext(nsError.domain)
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }

    func fetchSeriesLaunchesList() {
        isSeriesLoading.accept(true)
        fetchSeriesUseCase.execute(characterId: String(character?.id ?? 0), limit: limitSerie, offset: offsetSerie)
            .subscribe {[weak self] event in
                self?.isSeriesLoading.accept(false)
                self?.yearFilterTextFieldIsHidden.accept(false)
                guard let self = self else { return }
                switch event {
                case .next(let responseSeries):
                    self.handleResponseSeries(data: responseSeries)
                case .error(let error):
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
        fetchComicsLaunchesList()
        fetchSeriesLaunchesList()
    }

    func checkComicsRequestNewDataByIndex(index: Int) {
        if index == numLastComicToShow && loadMoreComic {
            fetchComicsLaunchesList()
        }
    }

    func checkSeriesRequestNewDataByIndex(index: Int) {
        if index == numLastSerieToShow && loadMoreSerie {
            fetchSeriesLaunchesList()
        }
    }

    func setFilterYearToItems() {
        if selectedFilteredYear == 0 {
            setupComics(comics: allComics)
            setupSeries(series: allSeries)

        } else {
            filteredComics = allComics.filter({$0.startYear == selectedFilteredYear})
            setupComics(comics: filteredComics)

            filteredSeries = allSeries.filter({$0.startYear == selectedFilteredYear})
            setupSeries(series: filteredSeries)
        }

    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func handleResponseComics(data: ResponseComics) {
        self.responseComics = data
        self.allComics += data.comics ?? []
        self.setupComics(comics: self.allComics)

        self.setYearsToFilter()

        offsetComic += limitComic

        self.loadMoreComic = PaginationHelper.isMoreDataToLoad(offset:offsetComic, total: self.responseComics?.total ?? 0)
    }

    private func setupComics(comics: [Comic]) {
        cellComicsUIModels = comics.map({ ComicSerieCell.UIModel(title: $0.title, year: DateHelper.dateToShortDate(date: $0.startDate ?? Date()), imageURL: $0.imageUrl) })

        setItems(uiComicsModels: cellComicsUIModels, uiSeriesModels: cellSeriesUIModels)
    }

    private func handleResponseSeries(data: ResponseSeries) {
        self.responseSeries = data
        self.allSeries += data.series ?? []
        self.setupSeries(series: self.allSeries)

        self.setYearsToFilter()

        offsetSerie += limitSerie

        self.loadMoreSerie = PaginationHelper.isMoreDataToLoad(offset: offsetSerie, total: self.responseSeries?.total ?? 0)
    }

    private func setupSeries(series: [Serie]) {
        cellSeriesUIModels = series.map({ ComicSerieCell.UIModel(title: $0.title, year: String($0.startYear ?? 0), imageURL: $0.imageUrl) })

        setItems(uiComicsModels: cellComicsUIModels, uiSeriesModels: cellSeriesUIModels)
    }

    private func setItems(uiComicsModels: [ComicSerieCell.UIModel], uiSeriesModels: [ComicSerieCell.UIModel]) {
        items.onNext([SectionModel(model: "Comics", items: uiComicsModels), SectionModel(model: "Series", items: uiSeriesModels)])
    }

    private func setYearsToFilter() {
        yearsToFilter.onNext(Array(Set([0] + allComics.compactMap({ $0.startYear }) + allSeries.compactMap({ $0.startYear }))).sorted())
    }

}
