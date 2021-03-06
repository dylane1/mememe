//
//  MainViewModel.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


/** 
 * MainView listens for changes to image and updates the view accordingly
 */

import UIKit

struct MemeEditorViewModel: MemeEditorViewDataSource {
    internal let image: Dynamic<UIImage?>
    internal let topText: Dynamic<String>
    internal let bottomText: Dynamic<String>
    internal let font: Dynamic<UIFont>
    internal let fontColor: Dynamic<UIColor>
    
    init() {
        image       = Dynamic(nil)
        topText     = Dynamic("")
        bottomText  = Dynamic("")
        font        = Dynamic(Constants.Font.impact)
        fontColor   = Dynamic(Constants.ColorScheme.white)
    }
}
