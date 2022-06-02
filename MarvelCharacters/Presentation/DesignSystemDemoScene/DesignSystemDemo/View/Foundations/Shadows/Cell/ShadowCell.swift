//
//  ShadowCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class ShadowCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowNameLabel: UILabel!

    static let kCellId = "ShadowCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(shadowName: String, backgroundColor: UIColor) {
        shadowNameLabel.dsConfigure(with: shadowName, font: .regularSmall, color: .dsGrayDark)
        shadowView.backgroundColor = backgroundColor

        selectionStyle = .none
    }
}
