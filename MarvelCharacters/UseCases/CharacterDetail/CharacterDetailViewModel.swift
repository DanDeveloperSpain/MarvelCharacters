//
//  CharacterDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import Foundation

final class CharacterDetailViewModel {
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
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
    
    private(set) var responseComicsData : ResponseComicsData? {
        didSet {
            self.bindingComic()
        }
    }
    
    private(set) var responseSeriesData : ResponseSeriesData? {
        didSet {
            self.bindingSerie()
        }
    }
    
    private(set) var errorMessaje : String? {
        didSet {
            self.bindingError()
        }
    }
    
    var bindingComic : (() -> ()) = {}
    var bindingSerie : (() -> ()) = {}
    var bindingError : (() -> ()) = {}
    
    //------------------------------------------------
    // MARK: - Init
    //------------------------------------------------
    
    init(character: Character, characterService: CharacterServiceProtocol) {
        self.character = character
        self.characterService = characterService
        getComics()
        getSeries()
    }

    //------------------------------------------------
    // MARK: - Backend
    //------------------------------------------------
    
    func getComics() {
        characterService.requestGetComicsByCharacter(characterId: character?.id ?? 0,limit: limitComic, offset: offsetComic, withSuccess: { (result) in
            
            self.comics += result.all ?? []
            self.responseComicsData = result

            if (self.responseComicsData?.count ?? 0) == (self.responseComicsData?.limit ?? 0) {
                self.loadMoreComic = true
            }
            
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
            self.responseSeriesData = result

            if (self.responseSeriesData?.count ?? 0) == (self.responseSeriesData?.limit ?? 0) {
                self.loadMoreSerie = true
            }
            
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
