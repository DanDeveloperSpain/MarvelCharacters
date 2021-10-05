//
//  HomeViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit

protocol HomeViewControllerProtocol: BaseControllerViewModelProtocol {
    func loadCharacters() -> Void
    func loadError() -> Void
}

final class HomeViewController: BaseViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    //------------------------------------------------
    // MARK: - Variables and constants
    //------------------------------------------------
    
    private var viewModel: HomeViewModel? {
        return self._viewModel as? HomeViewModel
    }
 
    //------------------------------------------------
    // MARK: - LifeCycle
    //------------------------------------------------

     override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    //------------------------------------------------
    // MARK: - Setup view
    //------------------------------------------------
    override internal func setup() {
        configureView()
        configureCollectionView()
       
        activityIndicator.startAnimating()
       
    }
    
    //------------------------------------------------
    // MARK: - Button actions
    //------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        viewModel?.loadView()
    }

    //------------------------------------------------
    // MARK: - Private methods
    //------------------------------------------------
    private func configureView() {
        self.title = viewModel?.title
        tryAgainButton.isHidden = true
        tryAgainButton.setTitleColor(.whiteColor, for: .normal)
        activityIndicator.color = .secondaryColor
    }
    
    private func updateDataSource() {
        self.activityIndicator.stopAnimating()
        charactersCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        self.charactersCollectionView.register(UINib(nibName: CharacterCell.kCellId, bundle: Bundle(for: CharacterCell.self)), forCellWithReuseIdentifier: CharacterCell.kCellId)
        
        self.charactersCollectionView.dataSource = self
        self.charactersCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let spacing : CGFloat = 12.0
        let widthCell = (UIScreen.main.bounds.width - spacing * 4)/3
        flowLayout.itemSize = CGSize(width: widthCell , height: widthCell + 20)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 0, right: spacing)
        self.charactersCollectionView.collectionViewLayout = flowLayout
    }
    
    private func showError() {
        activityIndicator.stopAnimating()
        tryAgainButton.isHidden = false
        viewModel?.showSimpleAlert(alertTitle: viewModel?.errorMessaje?.0 ?? "", alertMessage: viewModel?.errorMessaje?.1 ?? "")
    }
 
 }

//--------------------------------------------------------------
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//--------------------------------------------------------------

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.characters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.kCellId, for: indexPath) as? CharacterCell {
            
            if let character = self.viewModel?.characters[indexPath.row] {
                characterCell.fill(character: character)
                cell = characterCell
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Pagination
        if indexPath.row == viewModel?.numLastCharacterToShow && viewModel?.loadMore ?? false {
            self.activityIndicator.startAnimating()
            viewModel?.paginate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let characterSelected = viewModel?.characters[indexPath.row] {
            self.viewModel?.showCharacterDetail(character: characterSelected)
        }
     }
    
}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {
    
    func didLoadView() {
    }
    
    func loadCharacters() {
        self.tryAgainButton.isHidden = true
        self.updateDataSource()
    }
    
    func loadError() {
        self.showError()
    }
}
