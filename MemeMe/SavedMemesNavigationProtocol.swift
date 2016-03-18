//
//  SavedMemesNavigation.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

/** 
  Using the name SavedMemesNavigationProtocol because it makes more sense than
  adding 'able' to make SavedMemesNavigationable or SavedMemesNavigable
 */
protocol SavedMemesNavigationProtocol {
    var savedMemesNavController: SavedMemesNavigationController { get }
}

extension SavedMemesNavigationProtocol where Self: UIViewController {
    var savedMemesNavController: SavedMemesNavigationController {
        return navigationController as! SavedMemesNavigationController
    }

    //MARK: - Configuration
    
    internal func configureNavigationItems(withMemeEditorNavController navController: MemeEditorNavigationController) {
        let addButtonClosure = { [weak self] in
            self!.presentViewController(navController, animated: true, completion: nil)
        }
        savedMemesNavController.configure(withAddClosure: addButtonClosure)
    }
    
    internal func configureDetailVC(forMeme meme: Meme, segue: UIStoryboardSegue) {
        if segue.identifier == Constants.SegueIDs.memeDetail {
            let savedMemeVC = segue.destinationViewController as! SavedMemeDetailViewController
            savedMemeVC.title = meme.topText
            savedMemeVC.configure(withMeme: meme)
        }
    }
}