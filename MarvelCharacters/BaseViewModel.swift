//
//  BaseViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation

protocol BaseControllerViewModelProtocol: AnyObject {

    func didLoadView()
    
}

protocol BaseViewModelProtocol {
    
    // Load data
    func loadView()
}

class BaseViewModel: BaseViewModelProtocol {
    
    // MARK: - Variables
    weak var baseView: BaseControllerViewModelProtocol?
    var _router: BaseRouter?
    
    // MARK: - Init
    init(router: BaseRouter) {
        self._router = router
    }
    
    func setView(_ view: BaseControllerViewModelProtocol) {
        self.baseView = view
    }
    
    // MARK: - Life Cycle
    func loadView() {
        self.baseView?.didLoadView()
    }
    
    func showSimpleAlert(alertTitle: String, alertMessage: String) {
        self._router?.showSimpleAlertAccept(alertTitle: alertTitle, alertMessage: alertMessage)
    }
    
}
