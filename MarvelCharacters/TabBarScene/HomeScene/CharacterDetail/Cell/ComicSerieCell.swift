//
//  ComicSerieCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import Kingfisher
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

        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }

    func fill(title: String, year: String, urlImge: String) {
        thumbnailImageView.kf.setImage(with: URL(string: urlImge), placeholder: DSImage(named: .marverComics))
        titleLabel.dsConfigure(with: title, font: .boldSmall, color: .dsWhite)
        yearLabel.dsConfigure(with: year, font: .boldMini, color: .dsPrimaryPure)
    }

}
