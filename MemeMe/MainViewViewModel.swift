//
//  MainViewModel.swift
//  MemeMe
//
//  Created by Dylan Edwards on 2/3/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


//TODO: DOCUMENTATION

import UIKit

struct MainViewViewModel: MainViewDataSource {
    let image: Dynamic<UIImage?>
    
    init() {
        image = Dynamic(nil)
    }
    
}