//
//  Extensions.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    /** Set by presenting view controller */
    internal var vcShouldBeDismissed: (() -> Void)?
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        magic("\(self.description) has been loaded   ---------------->")
        setNavigationBarAttributes()
    }
    
    private func setNavigationBarAttributes() {
        
        navigationBar.barTintColor = Constants.ColorScheme.darkBlue
        navigationBar.tintColor    = Constants.ColorScheme.white
        navigationBar.translucent  = true
        
        let titleLabelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.white,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
