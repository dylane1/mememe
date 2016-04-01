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
    
    internal func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        
        navigationBar.barTintColor = Constants.ColorScheme.darkBlue
        navigationBar.tintColor    = Constants.ColorScheme.white
        navigationBar.translucent  = true
        
        let shadow = NSShadow()
        shadow.shadowColor = Constants.ColorScheme.veryDarkBlue
        shadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
        
        var titleLabelAttributes: [String : AnyObject] = [
            NSShadowAttributeName: shadow,
            NSForegroundColorAttributeName : Constants.ColorScheme.white]
        
        if isTitle {
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.markerFelt, size: 24)!
        } else {
            titleLabelAttributes[NSFontAttributeName] = UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
