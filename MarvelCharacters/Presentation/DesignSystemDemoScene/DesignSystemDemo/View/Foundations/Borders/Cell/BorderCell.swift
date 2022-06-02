//
//  BorderCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 14/5/22.
//

import UIKit
import DanDesignSystem

class BorderCell: UITableViewCell {

    @IBOutlet weak var borderNameLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderRadiusPxLabel: UILabel!

    static let kCellId = "BorderCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(borderName: String, borderRadiusPx: String) {
        borderNameLabel.dsConfigure(with: borderName, font: .regularSmall, color: .dsGrayDark)
        borderRadiusPxLabel.dsConfigure(with: borderRadiusPx, font: .regularSmall, color: .dsGrayDark)

        selectionStyle = .none
    }
}
