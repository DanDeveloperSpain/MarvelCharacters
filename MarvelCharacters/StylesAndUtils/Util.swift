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
    
    func stringDateToShortDate(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateStyle = .medium
        
        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
    
}
