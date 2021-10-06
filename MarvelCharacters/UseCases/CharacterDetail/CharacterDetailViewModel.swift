//
//  CharacterDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation
import UIKit

final class CharacterDetailViewModel: BaseViewModel {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    /// Set the view of the model.
    private weak var view: CharacterDetailViewControllerProtocol? {
        return self.baseView as? CharacterDetailViewControllerProtocol
    }
    
    /// Set the router of the model.
    private var router: CharacterDetailRouter? {
        return self._router as? CharacterDetailRouter
    }
    
    var title: String {
        return character?.name ?? ""
    }
    
    let characterService : CharacterServiceProtocol
    
    let limitComic = 20
    let limitSerie = 20
    var offsetComic = 0
    var offsetSerie = 0
    var loadMoreComic = false
    var loadMoreSerie = false
    
    private(set) var character : Character?
    
    /// Comics datasource.
    private(set) var comics : [Comic] = []
    
    /// Series datasource.
    private(set) var series : [Serie] = []
    
    
    /// Indicate the last comic that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastComicToShow : Int {
        return characterService.numLastItemToShow(offset: comicsDataResponse?.offset ?? 0, all: comicsDataResponse?.all?.count ?? 0)
    }
    
    /// Indicate the last serie that will be shown in the list, to know when to make the next request to obtain more characters.
    var numLastSerieToShow : Int {
        return characterService.numLastItemToShow(offset: seriesDataResponse?.offset ?? 0, all: seriesDataResponse?.all?.count ?? 0)
    }
    
    /// Comic binding to notify the view.
    private(set) var comicsDataResponse : ResponseComicsData? {
        didSet {
            self.view?.loadComics()
        }
    }
    
    /// Serie binding to notify the view.
    private(set) var seriesDataResponse : ResponseSeriesData? {
        didSet {
            self.view?.loadSeries()
        }
    }
    
    private(set) var errorMessaje : String? {
        didSet {
            self.view?.loadError()
        }
    }
    
    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------
    
    /// Create a new CharacterDetailViewModel
    /// - Parameters:
    ///   - router: characterDetailRouter
    ///   - character: character to show
    ///   - characterService: Api call service.
    init(router: BaseRouter, character: Character, characterService: CharacterServiceProtocol) {
        self.character = character
        self.characterService = characterService
        super.init(router: router)
    }
    
    /// First call of viewmodel lifecycle.
    override func loadView() {
        getComics()
        getSeries()
    }

    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    /// Request comics data to CharacterService (API).
    func getComics() {
        characterService.requestGetComicsByCharacter(characterId: character?.id ?? 0,limit: limitComic, offset: offsetComic, withSuccess: { (result) in
            
            self.comics += result.all ?? []
            self.comicsDataResponse = result

            self.loadMoreComic = self.characterService.isMoreDataToLoad(offset: self.comicsDataResponse?.offset ?? 0, total: self.comicsDataResponse?.total ?? 0, limit: self.limitComic)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
        
    }

    /// Next request if there are more comic, when we reach the end of the list.
    func paginateComic() {
        offsetComic += limitComic
        getComics()
    }
    
    /// Request series data to CharacterService (API).
    func getSeries() {
        characterService.requestGetSeriesByCharacter(characterId: character?.id ?? 0,limit: limitSerie, offset: offsetSerie, withSuccess: { (result) in
            self.series += result.all ?? []
            self.seriesDataResponse = result

            self.loadMoreSerie = self.characterService.isMoreDataToLoad(offset: self.seriesDataResponse?.offset ?? 0, total: self.seriesDataResponse?.total ?? 0, limit: self.limitSerie)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
        
    }
    
    /// Next request if there are more serie, when we reach the end of the list.
    func paginateSerie() {
        if loadMoreSerie {
            offsetSerie += limitSerie
            getSeries()
        }
    }
    
}
