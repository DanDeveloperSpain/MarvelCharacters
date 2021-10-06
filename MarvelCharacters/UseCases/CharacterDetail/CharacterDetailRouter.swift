//
//  CharacterDetailRouter.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation

final class CharacterDetailRouter: BaseRouter {
    
    /// Get the character detail screen.
    /// - Parameters:
    ///   - character: character to show.
    ///   - characterService: api call service.
    /// - Returns: The CharacterDetailViewController with all structure properly linked (ViewController, ViewModel and Router).
    static func get(character: Character, characterService: CharacterServiceProtocol) -> CharacterDetailViewController {
        
        let router = CharacterDetailRouter()
        let viewModel = CharacterDetailViewModel(router: router, character: character, characterService: characterService)
        let viewController = CharacterDetailViewController(viewModel: viewModel)
        
        viewModel.setView(viewController)

        router.viewController = viewController

        return viewController
    }
    
}
