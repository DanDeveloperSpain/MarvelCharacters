//
//  CharacterCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 30/9/21.
//

import UIKit
import Kingfisher

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

        characterImageView.kf.cancelDownloadTask()
        characterImageView.image = nil
    }

    func fill(characterName: String, urlImge: String) {
        characterImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "marverComics"))
        characterNameLabel.configure(with: characterName, font: .boldSmall, color: .whiteColor)
    }

}
