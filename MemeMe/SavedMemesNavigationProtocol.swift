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

extension SavedMemesNavigationProtocol where Self: UIViewController, Self: MemeEditorPresentable {
    
    var savedMemesNavController: SavedMemesNavigationController {
        return navigationController as! SavedMemesNavigationController
    }

    internal func configureNavigationItems() {
        
        let addButtonClosure = { [weak self] in
            self!.memeEditorNavController = self!.getMemeEditorNavigationController()
            self!.presentViewController(self!.memeEditorNavController!, animated: true, completion: nil)
        }
        savedMemesNavController.configure(withAddClosure: addButtonClosure)
    }
    
    internal func configureDetailViewController(forMeme meme: Meme, selectedIndex: Int, segue: UIStoryboardSegue, deletionClosure: ()->Void) {
        
        if segue.identifier == Constants.SegueID.memeDetail {
            
            let savedMemeVC = segue.destinationViewController as! SavedMemeDetailViewController
            
            savedMemeVC.title = (meme.topText != "") ? meme.topText : meme.bottomText
            
            savedMemeVC.configure(withMeme: meme, selectedIndex: selectedIndex, deletionClosure: deletionClosure)
        }
    }
}