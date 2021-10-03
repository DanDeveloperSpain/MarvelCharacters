//
//  CharacterDetailRouter.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation

final class CharacterDetailRouter: BaseRouter {
    
    static func get(character: Character, characterService: CharacterServiceProtocol) -> CharacterDetailViewController {
        
        let router = CharacterDetailRouter()
        let viewModel = CharacterDetailViewModel(router: router, character: character, characterService: characterService)
        let viewController = CharacterDetailViewController(viewModel: viewModel)
        
        viewModel.setView(viewController)

        router.viewController = viewController

        return viewController
    }
    
    
}
