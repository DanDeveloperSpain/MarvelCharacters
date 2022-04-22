//
//  ComicSerieCell.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 1/10/21.
//

import UIKit
import Kingfisher

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
        thumbnailImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "marverComics"))
        titleLabel.configure(with: title, font: .boldSmall, color: .whiteColor)
        yearLabel.configure(with: year, font: .semiboldSmall, color: .principalColor)
    }

}
