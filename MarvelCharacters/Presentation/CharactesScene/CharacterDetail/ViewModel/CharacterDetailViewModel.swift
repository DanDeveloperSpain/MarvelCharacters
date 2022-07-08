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

    /// Comics datasource.
    private(set) var comics: [Comic] = []

    var responseComicsData: ResponseComicsData?

    /// Series datasource.
    private(set) var series: [Serie] = []

    var responseSeriesData: ResponseSeriesData?

    /// Indicate the last comic that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastComicToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseComicsData?.offset ?? 0, all: responseComicsData?.all?.count ?? 0)
    }
    /// Indicate the last serie that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastSerieToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseSeriesData?.offset ?? 0, all: responseSeriesData?.all?.count ?? 0)
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

    let items: PublishSubject<[SectionModel<String, ComicSerieCell.UIModel>]> = PublishSubject()
    var cellComicsUIModels = [ComicSerieCell.UIModel]()
    var cellSeriesUIModels = [ComicSerieCell.UIModel]()
    let isComicsLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isSeriesLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
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
                guard let self = self else { return }
                switch event {
                case .next(let responseComicsData):
                    self.handleResponseComicsDataData(data: responseComicsData)
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
                guard let self = self else { return }
                switch event {
                case .next(let responseSeriesData):
                    self.handleResponseSeriesDataData(data: responseSeriesData)
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

    func checkComicsRequestNewDataByIndex(index: Int) {
        if index == numLastComicToShow && loadMoreComic {
            paginateComics()
        }
    }

    func checkSeriesRequestNewDataByIndex(index: Int) {
        if index == numLastSerieToShow && loadMoreSerie {
            paginateSeries()
        }
    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func handleResponseComicsDataData(data: ResponseComicsData) {
        self.responseComicsData = data
        self.comics += data.all ?? []
        self.setupComicsData(comics: self.comics)

        self.loadMoreComic = PaginationHelper.isMoreDataToLoad(offset: self.responseComicsData?.offset ?? 0, total: self.responseComicsData?.total ?? 0, limit: self.limitComic)
    }

    private func setupComicsData(comics: [Comic]) {
        cellComicsUIModels.removeAll()

        comics.forEach { comic in
            cellComicsUIModels.append(ComicSerieCell.UIModel(title: comic.title, year: comic.year, imageURL: "\(comic.thumbnail?.path ?? "").\(comic.thumbnail?.typeExtension ?? "")"))
        }

        setItems(uiComicsModels: cellComicsUIModels, uiSeriesModels: cellSeriesUIModels)
    }

    private func handleResponseSeriesDataData(data: ResponseSeriesData) {
        self.responseSeriesData = data
        self.series += data.all ?? []
        self.setupSeriesData(series: self.series)

        self.loadMoreSerie = PaginationHelper.isMoreDataToLoad(offset: self.responseSeriesData?.offset ?? 0, total: self.responseSeriesData?.total ?? 0, limit: self.limitSerie)
    }

    private func setupSeriesData(series: [Serie]) {
        cellSeriesUIModels.removeAll()

        series.forEach { serie in
            cellSeriesUIModels.append(ComicSerieCell.UIModel(title: serie.title, year: String(serie.startYear ?? 0), imageURL: "\(serie.thumbnail?.path ?? "").\(serie.thumbnail?.typeExtension ?? "")"))
        }

        setItems(uiComicsModels: cellComicsUIModels, uiSeriesModels: cellSeriesUIModels)
    }

    private func setItems(uiComicsModels: [ComicSerieCell.UIModel], uiSeriesModels: [ComicSerieCell.UIModel]) {
        items.onNext([SectionModel(model: "Comics", items: uiComicsModels), SectionModel(model: "Series", items: uiSeriesModels)])
    }

    private func paginateComics() {
        offsetComic += limitComic
        fetchComicsLaunchesList()
    }

    private func paginateSeries() {
        offsetSerie += limitSerie
        fetchSeriesLaunchesList()
    }

}
