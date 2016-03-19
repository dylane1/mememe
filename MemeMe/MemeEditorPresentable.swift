//
//  MemeEditorOpener.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MemeEditorPresentable {
    var memeEditorNavController: MemeEditorNavigationController { get }
}

extension MemeEditorPresentable where Self: UIViewController {
    var memeEditorNavController: MemeEditorNavigationController {
        let editorNavController = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.memesEditorNavController) as! MemeEditorNavigationController
        
        editorNavController.vcShouldBeDismissed = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        return editorNavController
    }
}
