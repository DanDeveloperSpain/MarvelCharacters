//
//  BaseViewModel.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 3/10/21.
//

import Foundation


/// Protocol to implement by ViewControllers
protocol BaseControllerViewModelProtocol: AnyObject {

    func didLoadView()
}

/// Protocol to implement by ViewModels
protocol BaseViewModelProtocol {
    
    func loadView()
}


/// Base for the ViewModels with the basic structure.
class BaseViewModel: BaseViewModelProtocol {
    
    weak var baseView: BaseControllerViewModelProtocol?
    var _router: BaseRouter?
    
    init(router: BaseRouter) {
        self._router = router
    }
    
    func setView(_ view: BaseControllerViewModelProtocol) {
        self.baseView = view
    }
    
    /// Life Cycle
    func loadView() {
        self.baseView?.didLoadView()
    }
    
    func showSimpleAlert(alertTitle: String, alertMessage: String) {
        self._router?.showSimpleAlertAccept(alertTitle: alertTitle, alertMessage: alertMessage)
    }
    
}
