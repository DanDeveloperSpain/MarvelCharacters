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
    
    func fill(character: Character) {
        let urlImge = "\(character.thumbnail?.path ?? "").\(character.thumbnail?.typeExtension ?? "")"
        characterImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "marverComics"))
        characterNameLabel.configure(with: character.name, font: .boldSmall, color: .whiteColor)
    }

}
