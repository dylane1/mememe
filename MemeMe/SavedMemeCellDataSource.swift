//
//  SavedMemeCellDataSource.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/8/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol SavedMemeCellDataSource {
    var title: String { get }
    var image: UIImage { get }
    var textAttributes: [String : AnyObject] { get }
}

extension SavedMemeCellDataSource {
    var textAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.black
        ]
    }
}

struct SavedMemeCellModel: SavedMemeCellDataSource {
    var title: String
    var image: UIImage
}
