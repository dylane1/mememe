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
    var textAttributes: [NSAttributedStringKey : Any] { get }
}

extension SavedMemeCellDataSource {
    var textAttributes: [NSAttributedStringKey : Any] {
        return [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Constants.ColorScheme.white,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue):     Constants.ColorScheme.black,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeWidth.rawValue):     -3.0 as AnyObject
        ]
    }
}

struct SavedMemeCellModel: SavedMemeCellDataSource {
    var meme: Meme
}
