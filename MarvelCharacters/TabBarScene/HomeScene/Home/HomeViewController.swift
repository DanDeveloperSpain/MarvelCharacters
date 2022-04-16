//
//  HomeViewController.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 29/9/21.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    //------------------------------------------------
    // MARK: - Properties
    //------------------------------------------------
    
    /// Set the model of the view.
    private var viewModel: HomeViewModel? {
        return self.baseViewModel as? HomeViewModel
    }
 
    //------------------------------------------------
    // MARK: - Life Cycle
    //------------------------------------------------
    
    /// IMPORTANT: setup will always run first
    /// viewDidLoad
    /// viewWillAppear
    /// viewDidAppear
    /// viewDidDisappear

    deinit {
        print("HomeViewController deinit")
    }

     override func viewDidLoad() {
         super.viewDidLoad()
         print("___ viewDidLoad HomeViewModel")
    }

    // ---------------------------------
    // MARK: - Setup View
    // ---------------------------------

    /// Setup the view.
    override internal func setup() {
        viewModel?.setView(self)
        configureView()
        configureCollectionView()
       
        activityIndicator.startAnimating()
        print("___ start HomeViewController")
    }
    
    //------------------------------------------------
    // MARK: - Buton Action's
    //------------------------------------------------

    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        viewModel?.start()
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
    
    /// Setup the charecterCollectionView flow layout.
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
        /// Pagination
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

//--------------------------------------------------------------
// MARK: - HomeViewModelViewDelegate
//--------------------------------------------------------------
extension HomeViewController: HomeViewModelViewDelegate {
    func showError() {
        activityIndicator.stopAnimating()
        tryAgainButton.isHidden = false
        self.showSimpleAlertAccept(alertTitle: viewModel?.errorMessaje?.0 ?? "", alertMessage: viewModel?.errorMessaje?.1 ?? "")
    }
    
    /// General notification when the view should be load.
    ///
    /// In this case we do not use it, we use loadCharacters since it is the only element in the whole view is the list of characters.
    func updateScreen() {
        print("updateScreen Home!!!")
    }
    
    /// Notifies that the characterDataSource has changed and the view needs to be updated.
    func loadCharacters() {
        self.tryAgainButton.isHidden = true
        self.updateDataSource()
    }
}
