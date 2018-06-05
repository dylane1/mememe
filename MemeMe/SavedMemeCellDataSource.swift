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
            NSAttributedStringKey.foregroundColor.rawValue: Constants.ColorScheme.white,
            NSAttributedStringKey.strokeColor.rawValue:     Constants.ColorScheme.black,
            NSAttributedStringKey.strokeWidth.rawValue:     -3.0 as AnyObject
        ]
    }
}

struct SavedMemeCellModel: SavedMemeCellDataSource {
    var meme: Meme
}
