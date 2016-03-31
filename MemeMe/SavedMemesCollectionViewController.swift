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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let title = (storedMemesProvider.memeArray[indexPath.row].topText != "") ? storedMemesProvider.memeArray[indexPath.row].topText : storedMemesProvider.memeArray[indexPath.row].bottomText
        
        let model = SavedMemeCellModel(title: title, image: storedMemesProvider.memeArray[indexPath.row].memedImage!, font: nil)
        
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
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
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
