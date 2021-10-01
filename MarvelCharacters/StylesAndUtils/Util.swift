//
//  Util.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit.UIAlert

final class Util {
    
    func showSimpleAlertAccept(viewController: UIViewController ,alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Accept", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        alert.view.tintColor = .PRINCIPAL_COLOR
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
