//
//  NavigationController.swift
//  Pitch Perfect
//
//  Created by Dylan Edwards on 1/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: get colors right: http://b2cloud.com.au/how-to-guides/bar-color-calculator-for-ios7-and-ios8/
//        navigationBar.barTintColor = GTColor.mediumGrey
//        navigationBar.tintColor    = GTColor.orange
        navigationBar.translucent  = true

        let titleLabelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.blue,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        ]
        //let titleAttributes: NSDictionary = [NSForegroundColorAttributeName: GTColor.white /*, NSFontAttributeName : font!*/]
        navigationBar.titleTextAttributes = titleLabelAttributes// as? [String : AnyObject]
    }
    
    //MARK: - Private funk(s)
    
}







