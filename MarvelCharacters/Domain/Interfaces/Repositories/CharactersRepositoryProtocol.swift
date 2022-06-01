//
//  CharactersRepositoryProtocol.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation
import RxSwift

protocol CharactersRepositoryProtocol: AnyObject {

    func fecthCharcters(limit: Int, offset: Int) -> Observable<ResponseCharactersData>

}
