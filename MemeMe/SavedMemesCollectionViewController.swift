//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesCollectionViewController: UICollectionViewController, SavedMemesNavigationProtocol, MemeEditorPresentable {
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)

    private var storedMemesProvider: MemesProvider!
    
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = LocalizedStrings.ViewControllerTitles.memeMe
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    private func configureCollectionView() {
        if storedMemesProvider.memeArray.count == 0 {
            let emptyDataSetVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.emptyDataSetVC) as! EmptyDataSetViewController
            
            collectionView!.backgroundView = emptyDataSetVC.view
        } else {
            collectionView!.backgroundView = nil
        }
        
        collectionView!.backgroundColor = Constants.ColorScheme.darkBlueGrey
        collectionView!.delegate = self
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let deletionClosure = {
            self.storedMemesProvider.removeMemeFromStorage(atIndex: self.selectedIndexPath.row)
            self.selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.collectionView!.reloadData()
        }
        configureDetailViewController(forMeme: storedMemesProvider.memeArray[selectedIndexPath.row], selectedIndex: selectedIndexPath.row, segue: segue, deletionClosure: deletionClosure)
    }
}

// MARK: - UICollectionViewDataSource
extension SavedMemesCollectionViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedMemesProvider.memeArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseID.memeListCollectionCell, forIndexPath: indexPath) as! SavedMemesCollectionViewCell
        
        let model = SavedMemeCellModel(meme: storedMemesProvider.memeArray[indexPath.row])
        
        cell.configure(withDataSource: model)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SavedMemesCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(Constants.SegueID.memeDetail, sender: self)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SavedMemesCollectionViewController {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = (view.frame.width / 2) - 5

        return CGSize(width: width, height: width*0.75)
    }
}

//MARK: - UIContentContainer
extension SavedMemesCollectionViewController {
    /** Resize cells upon rotation */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
    }
}
