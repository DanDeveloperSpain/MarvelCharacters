//
//  HeaderSupplementaryView.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 2/10/21.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    @IBOutlet weak var headerTitleLabel: UILabel!

    static let kCellId = "HeaderSupplementaryView"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(section: Int) {
        section == 0 ? headerTitleLabel.dsConfigure(with: NSLocalizedString("Comics", comment: ""), font: .boldLarge, color: .dsWhite) : headerTitleLabel.dsConfigure(with: NSLocalizedString("Series", comment: ""), font: .boldLarge, color: .dsWhite)
    }
}
