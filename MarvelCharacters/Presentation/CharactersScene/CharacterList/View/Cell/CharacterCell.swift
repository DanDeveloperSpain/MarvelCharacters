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

    struct UIModel {
        let characterName: String?
        let characterImageURL: String?
    }

    var uiModel: UIModel? {
        didSet {
            characterNameLabel.dsConfigure(with: uiModel?.characterName, font: .boldSmall, color: .dsWhite)
            characterImageView.sd_setImage(with: URL(string: uiModel?.characterImageURL ?? ""), placeholderImage: DSImage(named: .marverComics))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = 40
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        characterImageView.sd_cancelCurrentImageLoad()
        characterImageView.image = nil
    }

}
