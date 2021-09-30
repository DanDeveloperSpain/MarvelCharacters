//
//  HomeViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    

    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------

    let characterService = CharacterService()

    private(set) var homeViewModel: HomeViewModel?
 
    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------

     override func viewDidLoad() {
         super.viewDidLoad()
        
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)
        
        self.charactersCollectionView.dataSource = self
        self.charactersCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing : CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell , height: widthCell)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout


        homeViewModel = HomeViewModel(characterService: characterService)
        homeViewModel?.bindCharactersViewModelToController = {
            self.updateDataSource()
        }
    }

    private func updateDataSource(){
        print("get data successfully")
        charactersCollectionView.reloadData()
    }

 
 }

//--------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//--------------------------------------------------------------

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel?.charactersData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.kCellId, for: indexPath) as? CharacterCell {
            
            if let character = self.homeViewModel?.charactersData?.all[indexPath.row] {
                characterCell.characterNameLabel.text = character.name
                cell = characterCell
            }
            
        }
        
        return cell
    }
    
}
