//
//  SavedMemesNavigation.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol SavedMemesNavigation {
    var navController: SavedMemesNavigationController { get }
    var memeEditorNavController: MemeEditorNavigationController { get }
}

extension SavedMemesNavigation where Self: UIViewController {
    var navController: SavedMemesNavigationController {
        return navigationController as! SavedMemesNavigationController
    }
    
    var memeEditorNavController: MemeEditorNavigationController {
        let editorNavController = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.memesEditorNavController) as! MemeEditorNavigationController
        
        editorNavController.vcShouldBeDismissed = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        return editorNavController
    }
    
    internal func configureNavigationItems() {
        let addButtonClosure = { [weak self] in
            self!.presentViewController(self!.memeEditorNavController, animated: true, completion: nil)
        }
        navController.configure(withAddButtonClosure: addButtonClosure)
    }
}