//
//  MemeEditorOpener.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MemeEditorPresentable {
    var memeEditorNavController: NavigationController? { get set }
}

extension MemeEditorPresentable where Self: UIViewController {
    
    internal func getMemeEditorNavigationController() -> NavigationController {
        
        let editorNavController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.memesEditorNavController) as! NavigationController
        
        editorNavController.vcShouldBeDismissed = { [weak self] in
            self!.dismissViewControllerAnimated(true) {
                self!.memeEditorNavController = nil
            }
        }
        return editorNavController
    }
}
