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
        
        let editorNavController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.memesEditorNavController) as! NavigationController
        
        editorNavController.vcShouldBeDismissed = { [weak self] in
            self!.dismiss(animated: true) {
                self!.memeEditorNavController = nil
            }
        }
        return editorNavController
    }
}
