//
//  ComicSerieCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import SDWebImage
import DanDesignSystem

class ComicSerieCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    static let kCellId = "ComicSerieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        thumbnailImageView.sd_cancelCurrentImageLoad()
        thumbnailImageView.image = nil
    }

    func fill(title: String, year: String, urlImge: String) {
        thumbnailImageView.sd_setImage(with: URL(string: urlImge), placeholderImage: DSImage(named: .marverComics))
        titleLabel.dsConfigure(with: title, font: .boldSmall, color: .dsWhite)
        yearLabel.dsConfigure(with: year, font: .boldMini, color: .dsPrimaryPure)
    }

}
