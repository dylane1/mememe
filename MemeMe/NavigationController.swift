//
//  Extensions.swift
//  MemeMeister
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
        navigationBar.isTranslucent  = true
        
        let shadow = NSShadow()
        shadow.shadowColor = Constants.ColorScheme.veryDarkBlue
        shadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
        
        var titleLabelAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.shadow.rawValue): shadow,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : Constants.ColorScheme.white]
        
        if isTitle {
            titleLabelAttributes[NSAttributedStringKey.font] = UIFont(name: Constants.FontName.markerFelt, size: 24)!
        } else {
            titleLabelAttributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
