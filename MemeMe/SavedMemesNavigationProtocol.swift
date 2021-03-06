//
//  SavedMemesNavigation.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

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
            self!.present(self!.memeEditorNavController!, animated: true, completion: nil)
        }
        savedMemesNavController.configure(withAddClosure: addButtonClosure)
    }
    
    internal func configureDetailViewController(forMeme meme: Meme, selectedIndex: Int, segue: UIStoryboardSegue, deletionClosure: @escaping ()->Void) {
        
        if segue.identifier == Constants.SegueID.memeDetail {
            
            let savedMemeVC = segue.destination as! SavedMemeDetailViewController
            
            savedMemeVC.configure(withSelectedIndex: selectedIndex, deletionClosure: deletionClosure)
        }
    }
}
