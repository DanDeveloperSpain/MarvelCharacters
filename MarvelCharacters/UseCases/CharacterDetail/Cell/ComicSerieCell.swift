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
    
    func fill(comic: Comic){
        let urlImge = comic.thumbnail.path + "." + comic.thumbnail.typeExtension
        thumbnailImageView.kf.setImage(with: URL(string: urlImge), placeholder: UIImage(named: "marverComics"))
        titleLabel.text = comic.title
        yearLabel.text = comic.year
    }

}
