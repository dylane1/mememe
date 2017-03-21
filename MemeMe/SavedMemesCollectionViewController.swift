//
//  SavedMemesCollectionViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesCollectionViewController: UICollectionViewController, SavedMemesNavigationProtocol, MemeEditorPresentable {
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)

    fileprivate var storedMemesProvider: MemesProvider!
    
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = LocalizedStrings.ViewControllerTitles.memeMe
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)

        configureNavigationItems()
        
        storedMemesProvider = MemesProvider()
        
        configureCollectionView()
        
        collectionView!.reloadData()
    }

    //MARK: - Configuration
    
    fileprivate func configureCollectionView() {
        if storedMemesProvider.memeArray.count == 0 {
            let emptyDataSetVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.emptyDataSetVC) as! EmptyDataSetViewController
            
            collectionView!.backgroundView = emptyDataSetVC.view
        } else {
            collectionView!.backgroundView = nil
        }
        
        collectionView!.backgroundColor = Constants.ColorScheme.darkBlueGrey
        collectionView!.delegate = self
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let deletionClosure = {
            self.storedMemesProvider.removeMemeFromStorage(atIndex: self.selectedIndexPath.row)
            self.selectedIndexPath = IndexPath(row: 0, section: 0)
            self.collectionView!.reloadData()
        }
        configureDetailViewController(forMeme: storedMemesProvider.memeArray[selectedIndexPath.row], selectedIndex: selectedIndexPath.row, segue: segue, deletionClosure: deletionClosure)
    }
}

// MARK: - UICollectionViewDataSource
extension SavedMemesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedMemesProvider.memeArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseID.memeListCollectionCell, for: indexPath) as! SavedMemesCollectionViewCell
        
        let model = SavedMemeCellModel(meme: storedMemesProvider.memeArray[indexPath.row])
        
        cell.configure(withDataSource: model)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SavedMemesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: Constants.SegueID.memeDetail, sender: self)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SavedMemesCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width / 2) - 5

        return CGSize(width: width, height: width*0.75)
    }
}

//MARK: - UIContentContainer
extension SavedMemesCollectionViewController {
    /** Resize cells upon rotation */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
    }
}
