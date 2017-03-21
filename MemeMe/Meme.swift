//
//  Meme.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 2/19/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Meme {
    var image: UIImage?
    var topText: String
    var bottomText: String
    var font: UIFont
    var fontColor: UIColor
    var memedImage: UIImage?
    
    init() {
        topText     = ""
        bottomText  = ""
        font        = Constants.Font.impact
        fontColor   = Constants.ColorScheme.white
    }
}
