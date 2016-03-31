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
    }
    
    
    internal func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        
        navigationBar.barTintColor = Constants.ColorScheme.darkBlue
        navigationBar.tintColor    = Constants.ColorScheme.white
        navigationBar.translucent  = true
        
        let titleLabelAttributes: [String : AnyObject]
        if isTitle {
            let shadow = NSShadow()
            shadow.shadowColor = Constants.ColorScheme.veryDarkBlue
            shadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
            
            titleLabelAttributes = [
                NSShadowAttributeName: shadow,
                NSForegroundColorAttributeName : Constants.ColorScheme.white,
                NSFontAttributeName: UIFont(name: Constants.FontName.markerFelt, size: 24)! //UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
        } else {
            titleLabelAttributes = [
                NSForegroundColorAttributeName : Constants.ColorScheme.white,
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
