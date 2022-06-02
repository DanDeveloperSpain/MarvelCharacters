//
//  ButtonCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 15/5/22.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var stateButtonLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!

    static let kCellId = "ButtonCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(buttonsStateName: String) {
        stateButtonLabel.text = buttonsStateName
    }

}
