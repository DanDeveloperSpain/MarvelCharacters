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
    
    private weak var view: CharacterDetailViewControllerProtocol? {
        return self.baseView as? CharacterDetailViewControllerProtocol
    }
    
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
    private(set) var comics : [Comic] = []
    private(set) var series : [Serie] = []
    
    private(set) var comicsDataResponse : ResponseComicsData? {
        didSet {
            self.view?.loadComics()
        }
    }
    
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
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    init(router: BaseRouter, character: Character, characterService: CharacterServiceProtocol) {
        self.character = character
        self.characterService = characterService
        super.init(router: router)
    }
    
    // ------------------------------------------------
    // MARK: - ViewModel
    // ------------------------------------------------
    override func loadView() {
        getComics()
        getSeries()
    }
    
    func numLastComicToShow() -> Int {
        return (comicsDataResponse?.offset ?? 0) + (comicsDataResponse?.count ?? 0) - 1
    }
    
    func numLastSerieToShow() -> Int {
        return (seriesDataResponse?.offset ?? 0) + (seriesDataResponse?.count ?? 0) - 1
    }

    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    func getComics() {
        characterService.requestGetComicsByCharacter(characterId: character?.id ?? 0,limit: limitComic, offset: offsetComic, withSuccess: { (result) in
            
            self.comics += result.all ?? []
            self.comicsDataResponse = result

            self.loadMoreComic = self.characterService.isMoreDataToLoad(offset: self.comicsDataResponse?.offset ?? 0, total: self.comicsDataResponse?.total ?? 0, limit: self.limitComic)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
        
    }

    func paginateComic() {
        offsetComic += limitComic
        getComics()
    }
    
    func getSeries() {
        characterService.requestGetSeriesByCharacter(characterId: character?.id ?? 0,limit: limitSerie, offset: offsetSerie, withSuccess: { (result) in
            self.series += result.all
            self.seriesDataResponse = result

            self.loadMoreSerie = self.characterService.isMoreDataToLoad(offset: self.seriesDataResponse?.offset ?? 0, total: self.seriesDataResponse?.total ?? 0, limit: self.limitSerie)
            
        }, withFailure: { (error) in
            self.errorMessaje = error
        })
        
    }
    
    func paginateSerie() {
        if loadMoreSerie {
            offsetSerie += limitSerie
            getSeries()
        }
    }
    
}
