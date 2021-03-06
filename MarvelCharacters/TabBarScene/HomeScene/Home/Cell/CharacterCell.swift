//
//  CharacterCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import UIKit
import SDWebImage
import DanDesignSystem

class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!

    static let kCellId = "CharacterCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = 40
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        characterImageView.sd_cancelCurrentImageLoad()
        characterImageView.image = nil
    }

    func fill(characterName: String, urlImge: String) {
        characterImageView.sd_setImage(with: URL(string: urlImge), placeholderImage: DSImage(named: .marverComics))
        characterNameLabel.dsConfigure(with: characterName, font: .boldSmall, color: .dsWhite)
    }

}
