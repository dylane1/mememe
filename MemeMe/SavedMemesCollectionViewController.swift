//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SavedMemesCollectionViewController: UICollectionViewController, SavedMemesNavigation {
    
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    
    /** Storage */
    private var storedMemesProvider = MemesProvider()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        collectionView!.backgroundColor = Constants.ColorScheme.lightGrey
        collectionView!.delegate = self

        configureNavigationItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueIDs.memeDetail {
            let savedMemeVC = segue.destinationViewController as! SavedMemeViewController
            savedMemeVC.title = storedMemesProvider.memeArray[selectedIndexPath.row].topText
            savedMemeVC.configure(withMemeImage: storedMemesProvider.memeArray[selectedIndexPath.row].memedImage!)
        }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIDs.memeListCollectionCell, forIndexPath: indexPath) as! SavedMemesCollectionViewCell
        
        let title = (storedMemesProvider.memeArray[indexPath.row].topText != "") ? storedMemesProvider.memeArray[indexPath.row].topText : storedMemesProvider.memeArray[indexPath.row].bottomText
        
        let model = SavedMemeCellModel(title: title, image: storedMemesProvider.memeArray[indexPath.row].memedImage!)
        
        cell.configure(withDataSource: model)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SavedMemesCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(Constants.SegueIDs.memeDetail, sender: self)
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
