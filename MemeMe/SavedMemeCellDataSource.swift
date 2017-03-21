//
//  SavedMemeCellDataSource.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/8/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol SavedMemeCellDataSource {
    var meme: Meme { get }
    var textAttributes: [String : AnyObject] { get }
}

extension SavedMemeCellDataSource {
    var textAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.white,
            NSStrokeColorAttributeName:     Constants.ColorScheme.black,
            NSStrokeWidthAttributeName:     -3.0
        ]
    }
}

struct SavedMemeCellModel: SavedMemeCellDataSource {
    var meme: Meme
}
