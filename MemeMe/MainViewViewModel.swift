//
//  MainViewModel.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


/** 
 * MainView listens for changes to image and updates the view accordingly
 */

import UIKit

struct MainViewViewModel: MainViewDataSource {
    internal let image: Dynamic<UIImage?>
    internal let font: Dynamic<UIFont>
    internal let fontColor: Dynamic<UIColor>
    
    init() {
        image       = Dynamic(nil)
        font        = Dynamic(Constants.Fonts.impact)
        fontColor   = Dynamic(Constants.ColorScheme.white)
    }
}
