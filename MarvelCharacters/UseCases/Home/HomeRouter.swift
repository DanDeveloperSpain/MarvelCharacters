//
//  HomeRouter.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import Foundation

final class HomeRouter: BaseRouter {
    
    /// Get the app's home screen.
    /// - Returns: The HomeViewController with all structure properly linked (ViewController, ViewModel and Router).
    static func get() -> HomeViewController {
        
        let characterService = CharacterService()
        
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router, characterService: characterService)
        let viewController = HomeViewController(viewModel: viewModel)
        
        viewModel.setView(viewController)
        
        router.viewController = viewController
        
        return viewController
    }
    
    /// Display a character's detail screen.
    /// - Parameters:
    ///   - character: character to show.
    ///   - characterService: Api call service.
    func showCharacterDetail(character: Character, characterService: CharacterServiceProtocol) {
        let characterDetailVC = CharacterDetailRouter.get(character: character, characterService: characterService)
        navigate(toViewController: characterDetailVC)
    }
    
}
