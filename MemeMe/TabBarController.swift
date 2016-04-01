//
//  TabBarController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/29/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = Constants.ColorScheme.darkBlue
        tabBar.tintColor = Constants.ColorScheme.white
        
        /** Shift icon down */
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
