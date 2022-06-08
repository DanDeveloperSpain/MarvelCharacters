//
//  ComicsRepositoryProtocol.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol ComicsRepositoryProtocol: AnyObject {

    func fetchCharcters(limit: Int, offset: Int, characterId: String) -> Observable<ResponseComicsData>

}
