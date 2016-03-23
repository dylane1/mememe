//
//  Extensions.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

extension UINavigationController {
    /** Set by presenting view controller */
    internal var vcShouldBeDismissed: (() -> Void)?
    
    internal func setNavigationBarAttributes() {
        navigationBar.barTintColor = Constants.ColorScheme.white
        navigationBar.tintColor    = Constants.ColorScheme.darkBlue
        navigationBar.translucent  = true
        
        let titleLabelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.black,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
