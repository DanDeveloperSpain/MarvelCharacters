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

// ---------------------------------
// MARK: - View Delegates
// ---------------------------------
protocol CharacterDetailViewModelViewDelegate: BaseControllerViewModelProtocol {
    func showError()
    func loadComics()
    func loadSeries()
}

final class CharacterDetailViewModel { // : BaseViewModel {

    // MARK: - Variables
    private let fetchComicsUseCase: FetchComicsUseCaseProtocol
    private let fetchSeriesUseCase: FetchSeriesUseCaseProtocol
    let items: PublishSubject<[SectionModel<String, ComicSerieCell.UIModel>]> = PublishSubject()
    var cellComicsUIModels = [ComicSerieCell.UIModel]()
    var cellSeriesUIModels = [ComicSerieCell.UIModel]()
    let isComicsLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isSeriesLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMessage: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    var responseComicsData: ResponseComicsData?
    var responseSeriesData: ResponseSeriesData?

    // MARK: - Init
    init(coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate, fetchComicsUseCase: FetchComicsUseCaseProtocol, fetchSeriesUseCase: FetchSeriesUseCaseProtocol, character: Character) {
        self.coordinatorDelegate = coordinatorDelegate
        self.fetchComicsUseCase = fetchComicsUseCase
        self.fetchSeriesUseCase = fetchSeriesUseCase
        self.character = character
    }

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

    private func setupComicsData(comics: [Comic]) {
        cellComicsUIModels.removeAll()

        comics.forEach { comic in
            cellComicsUIModels.append(ComicSerieCell.UIModel(title: comic.title, year: comic.year, imageURL: "\(comic.thumbnail?.path ?? "").\(comic.thumbnail?.typeExtension ?? "")"))
        }

        setItems(uiComicsModels: cellComicsUIModels, uiSeriesModels: cellSeriesUIModels)
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

    // ---------------------------------
    // MARK: - Delegates
    // ---------------------------------

    private weak var coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate?

    /// Set the view of the model.
//    private weak var viewDelegate: CharacterDetailViewModelViewDelegate? {
//        return self.baseView as? CharacterDetailViewModelViewDelegate
//    }

    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------

    var title: String {
        return character?.name ?? ""
    }

    // let characterService: CharacterServiceProtocol

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

    /// Indicate the last comic that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastComicToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseComicsData?.offset ?? 0, all: responseComicsData?.all?.count ?? 0)
    }
//
//    /// Indicate the last serie that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastSerieToShow: Int {
        return PaginationHelper.numLastItemToShow(offset: responseSeriesData?.offset ?? 0, all: responseSeriesData?.all?.count ?? 0)
    }

    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------

    /// Create a new CharacterDetailViewModel.
    /// - Parameters:
    ///   - coordinatorDelegate: The coordinator delegate.
    ///   - character: Character to show.
    ///   - characterService: Api call service.
//    init(coordinatorDelegate: CharacterDetailViewModelCoordinatorDelegate, character: Character, characterService: CharacterServiceProtocol) {
//        self.coordinatorDelegate = coordinatorDelegate
//        self.character = character
//        self.characterService = characterService
//    }

    /// First call of viewmodel lifecycle.
//    override func start() {
//        Task {
//            try await getComics()
//            try await getSeries()
//        }
//    }

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

//    func numberOfSectionsInCollectionView() -> Int {
//          return numberOfSections
//        }
//
//    func numberOfItemsInSection(section: Int) -> Int {
//        switch section {
//        case 0:
//            return comics.count
//        case 1:
//            return series.count
//        default:
//            return 0
//        }
//    }
//
//    func titleAtIndex(index: Int, type: MediaType) -> String {
//        return type == .comic ? comics[index].title ?? "" : series[index].title ?? ""
//    }
//
//    func yearAtIndex(index: Int, type: MediaType) -> String {
//        return type == .comic ? comics[index].year ?? "" : series[index].startYear.map(String.init) ?? ""
//    }
//
//    func urlImgeAtIndex(index: Int, type: MediaType) -> String {
//        return type == .comic ? "\(comics[index].thumbnail?.path ?? "").\(comics[index].thumbnail?.typeExtension ?? "")" : "\(series[index].thumbnail?.path ?? "").\(series[index].thumbnail?.typeExtension ?? "")"
//    }

    /// Next request if there are more comic or serie, when we reach the end of the list.
//    func paginate(mediaType: MediaType) {
//
//        switch mediaType {
//        case .comic:
//            offsetComic += limitComic
//            Task {
//                try await getComics()
//            }
//        case .serie:
//            offsetSerie += limitSerie
//            Task {
//                try await getSeries()
//            }
//        }
//    }

    // ------------------------------------------------
    // MARK: - Private methods
    // ------------------------------------------------

    private func handleResponseComicsDataData(data: ResponseComicsData) {
        self.responseComicsData = data
        self.comics += data.all ?? []
        self.setupComicsData(comics: self.comics)

        self.loadMoreComic = PaginationHelper.isMoreDataToLoad(offset: self.responseComicsData?.offset ?? 0, total: self.responseComicsData?.total ?? 0, limit: self.limitComic)
    }

    private func handleResponseSeriesDataData(data: ResponseSeriesData) {
        self.responseSeriesData = data
        self.series += data.all ?? []
        self.setupSeriesData(series: self.series)

        self.loadMoreSerie = PaginationHelper.isMoreDataToLoad(offset: self.responseSeriesData?.offset ?? 0, total: self.responseSeriesData?.total ?? 0, limit: self.limitSerie)
    }

    private func paginateComics() {
        offsetComic += limitComic
        fetchComicsLaunchesList()
    }

    private func paginateSeries() {
        offsetSerie += limitSerie
        fetchSeriesLaunchesList()
    }

    // ------------------------------------------------
    // MARK: - Backend
    // ------------------------------------------------

}
