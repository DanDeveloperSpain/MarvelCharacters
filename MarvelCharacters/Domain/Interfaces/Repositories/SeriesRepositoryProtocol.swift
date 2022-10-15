//
//  SeriesRepositoryProtocol.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/6/22.
//

import Foundation
import RxSwift

protocol SeriesRepositoryProtocol: AnyObject {

    func fetchCharcters(characterId: String, limit: Int, offset: Int) -> Observable<ResponseSeries>

}
